import { sortBy } from 'common/collections';
import { classes } from 'common/react';
import { ReactNode } from 'react';

import { useSharedState } from '../../backend';
import { Dimmer, Icon, Section, Stack } from '../../components';
import { SearchBar } from '../common/SearchBar';
import { Design, MaterialMap } from './Types';

/**
 * A function that does nothing.
 */
const NOOP = () => {};

export type DesignBrowserProps<T extends Design = Design> = {
  /**
   * All of the designs available to the browser.
   */
  designs: T[];

  /**
   * A map of materials available for printing designs.
   */
  availableMaterials?: MaterialMap;

  /**
   * Invoked when the user attempts to print a design.
   */
  onPrintDesign?: (design: T, amount: number) => void;

  /**
   * If present, dims out the recipe list with a "building items" animation.
   */
  busy?: boolean;

  /**
   * Invoked for every recipe visible in the design browser. Returns a single
   * row to be rendered to the output.
   */
  buildRecipeElement: (
    /**
     * The design being rendered.
     */
    design: T,

    /**
     * The materials available to print the design.
     */
    availableMaterials: MaterialMap,

    /**
     * A callback to print the design.
     */
    onPrintDesign: (design: T, amount: number) => void,
  ) => ReactNode;

  /**
   * If provided, renders a node into each category in the output.
   */
  categoryButtons?: (category: Category<T>) => ReactNode;
};

/**
 * A meta-category that, when selected, renders all designs to the output.
 */
const ALL_CATEGORY = 'All Designs';

/**
 * A meta-category that collects all designs without a single category.
 */
const UNCATEGORIZED = '/Uncategorized';

/**
 * A single category in the category tree.
 */
type Category<T extends Design = Design> = {
  /**
   * The human-readable title of this category.
   */
  title: string;

  /**
   * The `id` of the `Section` rendering this category in the browser.
   */
  anchorKey: string;

  /**
   * The set of all designs appearing in this category its descendant
   * categories, grouped by design ID.
   */
  descendants: Record<string, T>;

  /**
   * All designs within this specific category.
   */
  children: T[];

  /**
   * The subcategories within this one, keyed by their titles.
   */
  subcategories: Record<string, Category<T>>;
};

/**
 * Categories present in this object are not rendered to the final fabricator
 * UI.
 */
const BLACKLISTED_CATEGORIES: Record<string, boolean> = {
  initial: true,
  core: true,
  hacked: true,
};

/**
 * A universal design browser. Takes an arbitrary array of designs, and
 * generates tabs, a search bar, and a list of designs. Each row of the
 * resulting table is generated by the provided `buildRecipeElement` function.
 */
export const DesignBrowser = <T extends Design = Design>(
  props: DesignBrowserProps<T>,
) => {
  const {
    designs,
    availableMaterials,
    onPrintDesign,
    buildRecipeElement,
    busy,
    categoryButtons,
  } = props;

  const [selectedCategory, setSelectedCategory] = useSharedState(
    'selected_category',
    ALL_CATEGORY,
  );

  const [searchText, setSearchText] = useSharedState('search_text', '');

  const onCategorySelected = (newCategory: string) => {
    if (newCategory === selectedCategory) {
      return;
    }

    setSelectedCategory(newCategory);
    setSearchText('');
  };

  // Build a root category from the designs.
  const root: Category<T> = {
    title: ALL_CATEGORY,
    anchorKey: ALL_CATEGORY.replace(/ /g, ''),
    descendants: {},
    children: [],
    subcategories: {},
  };

  // Sort every design into a single category in the tree.
  for (const design of designs) {
    // For designs without any categories, assign them to the "uncategorized"
    // category.
    const categories =
      design.categories.length === 0 ? [UNCATEGORIZED] : design.categories;

    for (const category of categories) {
      // If the category is a blacklisted meta-category, skip it entirely.
      if (BLACKLISTED_CATEGORIES[category]) {
        continue;
      }

      // Categories are slash-delimited.
      const nodes = category.split('/');

      // We always lead with a slash, so the first group is always empty.
      nodes.shift();

      // Find where this goes, and put it there.
      let parent = root;

      while (nodes.length > 0) {
        parent.descendants[design.id] = design;

        const node = nodes.shift()!;

        if (!parent.subcategories[node]) {
          parent.subcategories[node] = {
            title: node,
            anchorKey: node.replace(/ /g, ''),
            descendants: {},
            children: [],
            subcategories: {},
          };
        }

        parent = parent.subcategories[node]!;
      }

      // This is our leaf.
      parent.descendants[design.id] = design;
      parent.children.push(design);
    }
  }

  return (
    <Stack fill>
      {/* Left Column */}
      <Stack.Item width={'200px'}>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Section title="Categories" fitted />
            </Stack.Item>
            <Stack.Item grow>
              <Section fill style={{ overflow: 'auto' }}>
                <div className="FabricatorTabs">
                  <div
                    className={classes([
                      'FabricatorTabs__Tab',
                      selectedCategory === ALL_CATEGORY &&
                        'FabricatorTabs__Tab--active',
                    ])}
                    onClick={() => onCategorySelected(ALL_CATEGORY)}
                  >
                    <div className="FabricatorTabs__Label">
                      <div className="FabricatorTabs__CategoryName">
                        All Designs
                      </div>
                      <div className="FabricatorTabs__CategoryCount">
                        ({Object.entries(root.descendants).length})
                      </div>
                    </div>
                  </div>

                  {sortBy((category: Category) => category.title)(
                    Object.values(root.subcategories),
                  ).map((category) => (
                    <DesignBrowserTab
                      key={category.title}
                      category={category}
                      selectedCategory={selectedCategory}
                      setSelectedCategory={onCategorySelected}
                    />
                  ))}
                </div>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      {/* Right Column */}
      <Stack.Item grow>
        <Section
          title={
            searchText.length > 0
              ? `Results for "${searchText}"`
              : selectedCategory === ALL_CATEGORY
                ? 'All Designs'
                : selectedCategory
          }
          fill
        >
          <Stack vertical fill>
            <Stack.Item>
              <Section>
                <SearchBar
                  query={searchText}
                  onSearch={setSearchText}
                  placeholder={'Search all designs...'}
                />
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section fill style={{ overflow: 'auto' }}>
                {searchText.length > 0 ? (
                  sortBy((design: T) => design.name)(
                    Object.values(root.descendants),
                  )
                    .filter((design) =>
                      design.name
                        .toLowerCase()
                        .includes(searchText.toLowerCase()),
                    )
                    .map((design) =>
                      buildRecipeElement(
                        design,
                        availableMaterials || {},
                        onPrintDesign || NOOP,
                      ),
                    )
                ) : selectedCategory === ALL_CATEGORY ? (
                  <>
                    {sortBy((design: T) => design.name)(
                      Object.values(root.descendants),
                    ).map((design) =>
                      buildRecipeElement(
                        design,
                        availableMaterials || {},
                        onPrintDesign || NOOP,
                      ),
                    )}
                  </>
                ) : (
                  root.subcategories[selectedCategory] && (
                    <CategoryView
                      category={root.subcategories[selectedCategory]}
                      categoryButtons={categoryButtons}
                      availableMaterials={availableMaterials}
                      onPrintDesign={onPrintDesign}
                      buildRecipeElement={buildRecipeElement}
                    />
                  )
                )}
              </Section>
            </Stack.Item>
            {!!busy && (
              <Dimmer
                style={{
                  fontSize: '2em',
                  textAlign: 'center',
                }}
              >
                <Icon name="cog" spin />
                {' Building items...'}
              </Dimmer>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

type DesignBrowserTabProps<T extends Design = Design> = {
  category: Category<T>;
  depth?: number;
  maxDepth?: number;
  selectedCategory: string;
  setSelectedCategory: (newCategory: string) => void;
};

const DesignBrowserTab = <T extends Design = Design>(
  props: DesignBrowserTabProps<T>,
) => {
  let { category, depth, maxDepth, selectedCategory, setSelectedCategory } =
    props;

  depth ??= 0;
  maxDepth ??= 3;

  return (
    <div
      className={classes([
        'FabricatorTabs__Tab',
        /** Only highlight top-level categories. */
        depth === 0 &&
          selectedCategory === category.title &&
          'FabricatorTabs__Tab--active',
      ])}
      onClick={
        depth === 0
          ? /* For top-level categories, set the selected category. */
            () => setSelectedCategory(category.title)
          : /* For deeper categories, scroll the subcategory header into view. */
            () => {
              document.getElementById(category.anchorKey)?.scrollIntoView(true);
            }
      }
    >
      <div className="FabricatorTabs__Label">
        <div className="FabricatorTabs__CategoryName">{category.title}</div>
        {depth === 0 && (
          /** Show recipe counts on top-level categories. */
          <div className={'FabricatorTabs__CategoryCount'}>
            ({Object.entries(category.descendants).length})
          </div>
        )}
      </div>
      {depth < maxDepth &&
        Object.entries(category.subcategories).length > 0 &&
        selectedCategory === category.title && (
          <div className="FabricatorTabs">
            {sortBy((category: Category) => category.title)(
              Object.values(category.subcategories),
            ).map((subcategory) => (
              <DesignBrowserTab
                key={subcategory.title}
                category={subcategory}
                depth={(depth || 0) + 1}
                maxDepth={maxDepth}
                selectedCategory={selectedCategory}
                setSelectedCategory={setSelectedCategory}
              />
            ))}
          </div>
        )}
    </div>
  );
};

type CategoryViewProps<T extends Design = Design> = {
  /**
   * The category being rendered.
   */
  category: Category<T>;

  /**
   * A map of materials available for printing designs.
   */
  availableMaterials?: MaterialMap;

  /**
   * The depth of this category in the view.
   */
  depth?: number;

  /**
   * Invoked when the user attempts to print a design.
   */
  onPrintDesign?: (design: T, amount: number) => void;

  /**
   * Invoked for every recipe visible in the design browser. Returns a single
   * row to be rendered to the output.
   */
  buildRecipeElement: (
    /**
     * The design being rendered.
     */
    design: T,

    /**
     * The materials available to print the design.
     */
    availableMaterials: MaterialMap,

    /**
     * A callback to print the design.
     */
    onPrintDesign: (design: T, amount: number) => void,
  ) => ReactNode;

  /**
   * If provided, renders a node into each category in the output.
   */
  categoryButtons?: (category: Category<T>) => ReactNode;
};

const CategoryView = <T extends Design = Design>(
  props: CategoryViewProps<T>,
) => {
  let {
    depth,
    category,
    availableMaterials,
    onPrintDesign,
    buildRecipeElement,
    categoryButtons,
  } = props;

  depth ??= 0;

  const body = (
    <>
      {sortBy((design: T) => design.name)(category.children).map((design) =>
        buildRecipeElement(
          design,
          availableMaterials || {},
          onPrintDesign || NOOP,
        ),
      )}

      {Object.keys(category.subcategories)
        .sort()
        .map((categoryName: string) => category.subcategories[categoryName])
        .map((category) => (
          <CategoryView
            {...props}
            depth={(depth || 0) + 1}
            category={category}
            key={category.title}
          />
        ))}
    </>
  );

  if (depth === 0 || category.children.length === 0) {
    return body;
  }

  return (
    <Section
      title={category.title}
      key={category.anchorKey}
      buttons={categoryButtons && categoryButtons(category)}
    >
      {body}
    </Section>
  );
};

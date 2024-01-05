import { filterMap } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Icon,
  Popper,
  Stack,
  Tooltip,
  TrackOutsideClicks,
} from '../../components';
import { PreferencesMenuData, Quirk, RandomSetting, ServerData } from './data';
import { getRandomization, PreferenceList } from './MainPage';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';
import { useRandomToggleState } from './useRandomToggleState';

function getValueClass(value: number) {
  if (value > 0) {
    return 'positive';
  } else if (value < 0) {
    return 'negative';
  } else {
    return 'neutral';
  }
}

function getCorrespondingPreferences(
  customization_options: string[],
  relevant_preferences: Record<string, string>,
) {
  return Object.fromEntries(
    filterMap(Object.keys(relevant_preferences), (key) => {
      if (!customization_options.includes(key)) {
        return undefined;
      }

      return [key, relevant_preferences[key]];
    }),
  );
}

type QuirkEntry = [string, Quirk & { failTooltip?: string }];

type QuirkListProps = {
  quirks: QuirkEntry[];
};

type QuirkProps = {
  // eslint-disable-next-line react/no-unused-prop-types
  onClick: (quirkName: string, quirk: Quirk) => void;
  randomBodyEnabled: boolean;
  selected: boolean;
  serverData: ServerData;
};

function QuirkList(props: QuirkProps & QuirkListProps) {
  const {
    quirks = [],
    selected,
    onClick,
    serverData,
    randomBodyEnabled,
  } = props;

  return (
    // Stack is not used here for a variety of IE flex bugs
    <Box className="PreferencesMenu__Quirks__QuirkList">
<<<<<<< HEAD
      {props.quirks.map(([quirkKey, quirk]) => {
        const [customizationExpanded, setCustomizationExpanded] =
          useLocalState<boolean>(quirk.name + ' customization', false);

        const className = 'PreferencesMenu__Quirks__QuirkList__quirk';

        const hasExpandableCustomization =
          quirk.customizable &&
          props.selected &&
          customizationExpanded &&
          quirk.customization_options &&
          Object.entries(quirk.customization_options).length > 0;

        const child = (
          <Box
            className={className}
            key={quirkKey}
            onClick={() => {
              if (props.selected) {
                setCustomizationExpanded(false);
              }
              props.onClick(quirkKey, quirk);
            }}
          >
            <Stack fill>
              <Stack.Item
                align="center"
                style={{
                  minWidth: '15%',
                  maxWidth: '15%',
                  textAlign: 'center',
                }}
              >
                <Icon color="#333" fontSize={3} name={quirk.icon} />
              </Stack.Item>

              <Stack.Item
                align="stretch"
                ml={0}
                style={{
                  borderRight: '1px solid black',
                }}
              />

              <Stack.Item
                grow
                ml={0}
                style={{
                  // Fixes an IE bug for text overflowing in Flex boxes
                  minWidth: '0%',
                }}
              >
                <Stack vertical fill>
                  <Stack.Item
                    className={`${className}--${getValueClass(quirk.value)}`}
                    style={{
                      borderBottom: '1px solid black',
                      padding: '2px',
                    }}
                  >
                    <Stack
                      fill
                      style={{
                        fontSize: '1.2em',
                      }}
                    >
                      <Stack.Item grow basis="content">
                        <b>{quirk.name}</b>
                      </Stack.Item>

                      <Stack.Item>
                        <b>{quirk.value}</b>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item
                    grow
                    basis="content"
                    mt={0}
                    style={{
                      padding: '3px',
                    }}
                  >
                    {quirk.description}
                    {!!quirk.customizable && (
                      <Popper
                        placement="bottom-end"
                        isOpen={customizationExpanded}
                        onClickOutside={() => {
                          setCustomizationExpanded(false);
                        }}
                        popperContent={
                          <Box>
                            {!!quirk.customization_options &&
                              hasExpandableCustomization && (
                                <Box
                                  mt="1px"
                                  style={{
                                    boxShadow:
                                      '0px 4px 8px 3px rgba(0, 0, 0, 0.7)',
                                  }}
                                >
                                  <Stack
                                    onClick={(e) => {
                                      e.stopPropagation();
                                    }}
                                    maxWidth="400px" // SKYRAT EDIT - maxWidth to 600px from 300px
                                    backgroundColor="black"
                                    px="5px"
                                    py="3px"
                                  >
                                    <Stack.Item>
                                      <PreferenceList
                                        act={act}
                                        preferences={getCorrespondingPreferences(
                                          quirk.customization_options,
                                          data.character_preferences
                                            .manually_rendered_features,
                                        )}
                                        randomizations={getRandomization(
                                          getCorrespondingPreferences(
                                            quirk.customization_options,
                                            data.character_preferences
                                              .manually_rendered_features,
                                          ),
                                          props.serverData,
                                          props.randomBodyEnabled,
                                        )}
                                        maxHeight="100px"
                                      />
                                    </Stack.Item>
                                  </Stack>
                                </Box>
                              )}
                          </Box>
                        }
                      >
                        {props.selected && (
                          <Button
                            selected={customizationExpanded}
                            icon="cog"
                            tooltip="Customize"
                            onClick={(e) => {
                              e.stopPropagation();

                              setCustomizationExpanded(!customizationExpanded);
                            }}
                            style={{
                              float: 'right',
                            }}
                          />
                        )}
                      </Popper>
                    )}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Box>
        );

        if (quirk.failTooltip) {
          return (
            <Tooltip key={quirkKey} content={quirk.failTooltip}>
              {child}
            </Tooltip>
          );
        } else {
          return child;
        }
      })}
=======
      {quirks.map(([quirkKey, quirk]) => (
        <QuirkDisplay
          key={quirkKey}
          onClick={onClick}
          quirk={quirk}
          quirkKey={quirkKey}
          randomBodyEnabled={randomBodyEnabled}
          selected={selected}
          serverData={serverData}
        />
      ))}
>>>>>>> 9dfc098cff6 (Fixes some character prefs issues (#80721))
    </Box>
  );
}

type QuirkDisplayProps = {
  quirk: Quirk & { failTooltip?: string };
  // bugged
  // eslint-disable-next-line react/no-unused-prop-types
  quirkKey: string;
} & QuirkProps;

function QuirkDisplay(props: QuirkDisplayProps) {
  const { quirk, quirkKey, onClick, selected } = props;
  const { icon, value, name, description, customizable, failTooltip } = quirk;

  const [customizationExpanded, setCustomizationExpanded] = useState(false);

  const className = 'PreferencesMenu__Quirks__QuirkList__quirk';

  const child = (
    <Box
      className={className}
      onClick={(event) => {
        event.stopPropagation();
        if (selected) {
          setCustomizationExpanded(false);
        }

        onClick(quirkKey, quirk);
      }}
    >
      <Stack fill>
        <Stack.Item
          align="center"
          style={{
            minWidth: '15%',
            maxWidth: '15%',
            textAlign: 'center',
          }}
        >
          <Icon color="#333" fontSize={3} name={icon} />
        </Stack.Item>

        <Stack.Item
          align="stretch"
          ml={0}
          style={{
            borderRight: '1px solid black',
          }}
        />

        <Stack.Item
          grow
          ml={0}
          style={{
            // Fixes an IE bug for text overflowing in Flex boxes
            minWidth: '0%',
          }}
        >
          <Stack vertical fill>
            <Stack.Item
              className={`${className}--${getValueClass(value)}`}
              style={{
                borderBottom: '1px solid black',
                padding: '2px',
              }}
            >
              <Stack
                fill
                style={{
                  fontSize: '1.2em',
                }}
              >
                <Stack.Item grow basis="content">
                  <b>{name}</b>
                </Stack.Item>

                <Stack.Item>
                  <b>{value}</b>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item
              grow
              basis="content"
              mt={0}
              style={{
                padding: '3px',
              }}
            >
              {description}
              {!!customizable && (
                <QuirkPopper
                  {...props}
                  customizationExpanded={customizationExpanded}
                  setCustomizationExpanded={setCustomizationExpanded}
                />
              )}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );

  if (failTooltip) {
    return <Tooltip content={failTooltip}>{child}</Tooltip>;
  } else {
    return child;
  }
}

type QuirkPopperProps = {
  customizationExpanded: boolean;
  setCustomizationExpanded: (expanded: boolean) => void;
} & QuirkDisplayProps;

function QuirkPopper(props: QuirkPopperProps) {
  const { act, data } = useBackend<PreferencesMenuData>();
  const {
    customizationExpanded,
    quirk,
    randomBodyEnabled,
    selected,
    serverData,
    setCustomizationExpanded,
  } = props;

  const { customizable, customization_options } = quirk;

  const { character_preferences } = data;

  const hasExpandableCustomization =
    customizable &&
    selected &&
    customizationExpanded &&
    customization_options &&
    Object.entries(customization_options).length > 0;

  return (
    <Popper
      placement="bottom-end"
      isOpen={customizationExpanded}
      popperContent={
        <TrackOutsideClicks
          onOutsideClick={() => setCustomizationExpanded(false)}
        >
          <Box>
            {!!customization_options && hasExpandableCustomization && (
              <Box
                mt="1px"
                style={{
                  boxShadow: '0px 4px 8px 3px rgba(0, 0, 0, 0.7)',
                }}
              >
                <Stack
                  onClick={(e) => {
                    e.stopPropagation();
                  }}
                  maxWidth="300px"
                  backgroundColor="black"
                  px="5px"
                  py="3px"
                >
                  <Stack.Item>
                    <PreferenceList
                      act={act}
                      preferences={getCorrespondingPreferences(
                        customization_options,
                        character_preferences.manually_rendered_features,
                      )}
                      randomizations={getRandomization(
                        getCorrespondingPreferences(
                          customization_options,
                          character_preferences.manually_rendered_features,
                        ),
                        serverData,
                        randomBodyEnabled,
                      )}
                      maxHeight="100px"
                    />
                  </Stack.Item>
                </Stack>
              </Box>
            )}
          </Box>
        </TrackOutsideClicks>
      }
    >
      {selected && (
        <Button
          selected={customizationExpanded}
          icon="cog"
          tooltip="Customize"
          onClick={(e) => {
            e.stopPropagation();
            setCustomizationExpanded(!customizationExpanded);
          }}
          style={{
            float: 'right',
          }}
        />
      )}
    </Popper>
  );
}

function StatDisplay(props) {
  const { children } = props;

  return (
    <Box
      backgroundColor="#eee"
      bold
      color="black"
      fontSize="1.2em"
      px={3}
      py={0.5}
    >
      {children}
    </Box>
  );
}

export function QuirksPage(props) {
  const { act, data } = useBackend<PreferencesMenuData>();

  // this is mainly just here to copy from MainPage.tsx
  const [randomToggleEnabled] = useRandomToggleState();
  const randomBodyEnabled =
    data.character_preferences.non_contextual.random_body !==
      RandomSetting.Disabled || randomToggleEnabled;

  const [selectedQuirks, setSelectedQuirks] = useState(data.selected_quirks);

  return (
    <ServerPreferencesFetcher
      // SKYRAT EDIT START - Quirks balance refactor
      render={(quirks_data) => {
        if (!quirks_data) {
          // SKYRAT EDIT END
          return <Box>Loading quirks...</Box>;
        }

        const {
          max_positive_quirks: maxPositiveQuirks,
          quirk_blacklist: quirkBlacklist,
          quirk_info: quirkInfo,
        } = quirks_data.quirks; // SKYRAT EDIT - Quirks balance refactor

        const quirks = Object.entries(quirkInfo);
        quirks.sort(([_, quirkA], [__, quirkB]) => {
          if (quirkA.value === quirkB.value) {
            return quirkA.name > quirkB.name ? 1 : -1;
          } else {
            return quirkA.value - quirkB.value;
          }
        });

        // SKYRAT EDIT START - Better Quirk Count Code
        let balance = -data.quirks_balance;
        let positiveQuirks = data.positive_quirk_count;
        // SKYRAT EDIT END

        const getReasonToNotAdd = (quirkName: string) => {
          const quirk = quirkInfo[quirkName];

          if (quirk.value > 0) {
            if (positiveQuirks >= maxPositiveQuirks) {
              return "You can't have any more positive quirks!";
            } else if (balance + quirk.value > 0) {
              return 'You need a negative quirk to balance this out!';
            }
          }

          // SKYRAT EDIT START - Veteran quirks
          if (quirk.veteran_only && !data.is_veteran) {
            return 'You need to be a veteran to select this quirk, apply today!';
          }
          // SKYRAT EDIT END

          const selectedQuirkNames = selectedQuirks.map((quirkKey) => {
            return quirkInfo[quirkKey].name;
          });

          for (const blacklist of quirkBlacklist) {
            if (blacklist.indexOf(quirk.name) === -1) {
              continue;
            }

            for (const incompatibleQuirk of blacklist) {
              if (
                incompatibleQuirk !== quirk.name &&
                selectedQuirkNames.indexOf(incompatibleQuirk) !== -1
              ) {
                return `This is incompatible with ${incompatibleQuirk}!`;
              }
            }
          }

          return undefined;
        };

        const getReasonToNotRemove = (quirkName: string) => {
          const quirk = quirkInfo[quirkName];

          if (balance - quirk.value > 0) {
            return 'You need to remove a positive quirk first!';
          }

          return undefined;
        };

        return (
          <Stack align="center" fill>
            <Stack.Item basis="50%">
              <Stack vertical fill align="center">
                <Stack.Item>
                  <Box fontSize="1.3em">Positive Quirks</Box>
                </Stack.Item>

                <Stack.Item>
                  <StatDisplay>
                    {positiveQuirks} / {maxPositiveQuirks}
                  </StatDisplay>
                </Stack.Item>

                <Stack.Item>
                  <Box as="b" fontSize="1.6em">
                    Available Quirks
                  </Box>
                </Stack.Item>

                <Stack.Item grow width="100%">
                  <QuirkList
                    selected={false}
                    onClick={(quirkName, quirk) => {
                      if (getReasonToNotAdd(quirkName) !== undefined) {
                        return;
                      }

                      setSelectedQuirks(selectedQuirks.concat(quirkName));

                      act('give_quirk', { quirk: quirk.name });
                    }}
                    quirks={quirks
                      .filter(([quirkName, _]) => {
                        return selectedQuirks.indexOf(quirkName) === -1;
                      })
                      .map(([quirkName, quirk]) => {
                        return [
                          quirkName,
                          {
                            ...quirk,
                            failTooltip: getReasonToNotAdd(quirkName),
                          },
                        ];
                      })}
                    serverData={quirks_data} // SKYRAT EDIT CHANGE
                    randomBodyEnabled={randomBodyEnabled}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item>
              <Icon name="exchange-alt" size={1.5} ml={2} mr={2} />
            </Stack.Item>

            <Stack.Item basis="50%">
              <Stack vertical fill align="center">
                <Stack.Item>
                  <Box fontSize="1.3em">Quirk Balance</Box>
                </Stack.Item>

                <Stack.Item>
                  <StatDisplay>{balance}</StatDisplay>
                </Stack.Item>

                <Stack.Item>
                  <Box as="b" fontSize="1.6em">
                    Current Quirks
                  </Box>
                </Stack.Item>

                <Stack.Item grow width="100%">
                  <QuirkList
                    selected
                    onClick={(quirkName, quirk) => {
                      if (getReasonToNotRemove(quirkName) !== undefined) {
                        return;
                      }

                      setSelectedQuirks(
                        selectedQuirks.filter(
                          (otherQuirk) => quirkName !== otherQuirk,
                        ),
                      );

                      act('remove_quirk', { quirk: quirk.name });
                    }}
                    quirks={quirks
                      .filter(([quirkName, _]) => {
                        return selectedQuirks.indexOf(quirkName) !== -1;
                      })
                      .map(([quirkName, quirk]) => {
                        return [
                          quirkName,
                          {
                            ...quirk,
                            failTooltip: getReasonToNotRemove(quirkName),
                          },
                        ];
                      })}
                    serverData={quirks_data} // sKYRAT EDIT CHANGE
                    randomBodyEnabled={randomBodyEnabled}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
}

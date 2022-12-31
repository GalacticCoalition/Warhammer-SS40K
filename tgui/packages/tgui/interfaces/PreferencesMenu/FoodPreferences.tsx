import { BooleanLike } from 'common/react';
import { useBackend } from '../../backend';
import { Section, Stack } from '../../components';
import { ButtonCheckbox } from '../../components/Button';
import { Window } from '../../layouts';

type Data = {
  food_types: Array<string>;
  selection: Record<number, Array<string>>;
  pref_literally_does_nothing: BooleanLike;
};

export const FoodPreferences = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Window width={600} height={777}>
      <Window.Content scrollable>
        {data.pref_literally_does_nothing ? (
          <h1>
            You&apos;re using a race which isn&apos;t affected by food
            preferences!
          </h1>
        ) : (
          <Stack vertical>
            {data.food_types.map((element) => {
              return (
                <Stack.Item key={element}>
                  <Section title={element}>
                    <FoodButton foodName={element} foodFlag={3} />
                    <FoodButton foodName={element} foodFlag={2} />
                    <FoodButton foodName={element} foodFlag={0} />
                    <FoodButton foodName={element} foodFlag={1} />
                  </Section>
                </Stack.Item>
              );
            })}
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

const FoodButton = (props, context) => {
  const { act } = useBackend(context);
  return (
    <ButtonCheckbox
      onClick={act('change_food', {
        food_name: props.foodName,
        food_flag: props.foodFlag,
      })}
    />
  );
};

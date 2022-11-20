/** Edits the key of a object. Does NOT change that keys assigned value and index */
export const editKeyOf = (
  icon_state: { [key: string]: number },
  old_key: string,
  new_key: string
) => {
  let returnval = {};
  Object.keys(icon_state).forEach((key) => {
    if (key === old_key) {
      let newPair = { [new_key]: icon_state[old_key] };
      returnval = { ...returnval, ...newPair };
    } else {
      returnval = { ...returnval, [key]: icon_state[key] };
    }
  });
  return returnval;
};

/** Edits the assigned weight of an object and returns the object*/
export const editWeightOf = (
  icon_state: { [key: string]: number },
  key: string,
  weight: number
) => {
  icon_state[key] = weight;
  return icon_state;
};

/** type assertion for string[] */
export const isStringArray = (value: any): value is string[] => {
  if (!Array.isArray(value)) {
    return false;
  }
  return value.every((x) => typeof x === 'string');
};

/** sets the "space" keys value on  an object, then returns that object*/
export const setGradientSpace = (
  gradient: (number | string)[],
  space: number
) => {
  gradient['space'] = space;
  return gradient;
};

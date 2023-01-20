export type Antagonist = Observable & { antag: string; antag_group: string };

export type AntagGroup = [string, Antagonist[]];

export type OrbitData = {
  alive: Observable[];
  antagonists: Antags;
  deadchat_controlled: Observable[];
  dead: Observable[];
  ghosts: Observable[];
  misc: Observable[];
  npcs: Observable[];
};

export type Observable = {
  extra?: string;
  full_name: string;
  health?: number;
  job?: string;
  job_icon?: string;
  name?: string;
  orbiters?: number;
  ref: string;
};

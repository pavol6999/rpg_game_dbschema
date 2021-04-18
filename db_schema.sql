CREATE TYPE damage_types AS ENUM (
  'pure',
  'magical',
  'physical'
);

CREATE TYPE status_effects AS ENUM (
  'slow',
  'stun',
  'damage_over_time',
  'heal',
  'silence',
  'cleanse'
);

CREATE TYPE item_type AS ENUM (
  'common',
  'rare',
  'epic',
  'legendary'
);

CREATE TYPE equip_slot AS ENUM (
  'feet',
  'legs',
  'hands',
  'neck',
  'head',
  'back',
  'right_hand',
  'left_hand',
  'body',
  'finger1',
  'finger2'
);

CREATE TYPE weapon_types AS ENUM (
  'short_sword',
  'long_sword',
  'bow',
  'crossbow',
  'staff',
  'mace',
  'knife',
  'dagger',
  'axe',
  'hammer'
);

CREATE TYPE permissions AS ENUM (
  'admin',
  'tester',
  'player',
  'moderator'
);

CREATE TYPE relationships AS ENUM (
  'friends',
  'ignored',
  'blocked'
);

CREATE TYPE gender AS ENUM (
  'male',
  'female'
);

CREATE TYPE quest_status AS ENUM (
  'completed',
  'failed',
  'active'
);



CREATE TABLE users (
  id SERIAL UNIQUE PRIMARY KEY,
  username varchar(32) NOT NULL UNIQUE CHECK(LENGTH(users.username) > 5),
  nickname varchar(50) NOT NULL,
  realname varchar(64) NOT NULL,
  email_address varchar(320) UNIQUE CHECK(users.email_address !~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
  password_hash varchar(32),
  banned boolean,
  newsletter boolean,
  signed_in_at timestamp,
  last_login timestamp,
  permission permissions,
  verified boolean,
  secret varchar(20)
);

CREATE TABLE friend_requests (
  id integer UNIQUE PRIMARY KEY,
  sender_id integer NOT NULL,
  receiver_id integer NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE map (
  id SERIAL PRIMARY KEY,
  name varchar(64) NOT NULL UNIQUE,
  x_size integer NOT NULL,
  y_size integer NOT NULL
);

CREATE TABLE messages (
  id BIGSERIAL UNIQUE PRIMARY KEY,
  sender integer NOT NULL,
  message_data text NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE rooms (
  id SERIAL UNIQUE PRIMARY KEY,
  name varchar(20),
  room_type varchar(10),
  private boolean
);

CREATE TABLE room_participants (
  id SERIAL PRIMARY KEY,
  user_id integer NOT NULL,
  room_id integer NOT NULL
);

CREATE TABLE map_objects (
  id SERIAL PRIMARY KEY,
  map_id integer NOT NULL,
  object_id integer NOT NULL,
  x_pos integer NOT NULL,
  y_pos integer NOT NULL,
  z_level integer NOT NULL
);

CREATE TABLE abilities (
  id SERIAL PRIMARY KEY,
  name varchar(20) UNIQUE,
  description varchar(100),
  ability_points_cost smallint DEFAULT 0,
  damage integer,
  heal integer,
  spell_type damage_types,
  splash_damage boolean,
  status_effect status_effects,
  status_duration smallint,
  mana_cost integer,
  health_cost integer
);

CREATE TABLE abilities_requirement (
  id SERIAL PRIMARY KEY,
  ability_id integer NOT NULL,
  required_ability_id integer NOT NULL,
  class_id integer
);

CREATE TABLE heroes_abilities (
  id SERIAL PRIMARY KEY,
  hero_id integer NOT NULL,
  ability_id integer NOT NULL
);

CREATE TABLE objects (
  id SERIAL PRIMARY KEY,
  name varchar(64) UNIQUE NOT NULL,
  object_filename bytea UNIQUE NOT NULL
);

CREATE TABLE npc_spawn_rules (
  id SERIAL PRIMARY KEY,
  map_id integer NOT NULL,
  x_pos integer NOT NULL,
  y_pos integer NOT NULL,
  z_level integer NOT NULL,
  dead_time integer NOT NULL,
  isSpawned boolean NOT NULL,
  group_size smallint NOT NULL DEFAULT 1,
  isUnique boolean NOT NULL,
  npc_id integer NOT NULL,
  npc_level integer NOT NULL,
  npc_level_range smallint NOT NULL,
  item_droprate_factor float NOT NULL,
  gold_reward_factor float NOT NULL,
  xp_reward_factor float NOT NULL,
  description text
);

CREATE TABLE players_locations (
  id SERIAL PRIMARY KEY,
  player_id integer UNIQUE NOT NULL,
  map_id integer NOT NULL,
  x_pos integer NOT NULL,
  y_pos integer NOT NULL,
  z_level integer NOT NULL
);

CREATE TABLE npc_spells (
  id SERIAL PRIMARY KEY,
  npc_id integer NOT NULL,
  ability_id integer NOT NULL
);

CREATE TABLE non_playable_characters (
  id SERIAL PRIMARY KEY,
  name varchar(50) UNIQUE NOT NULL,
  hostile boolean NOT NULL,
  uniqueness boolean NOT NULL,
  health_points integer NOT NULL,
  mana integer NOT NULL,
  attack_number integer NOT NULL,
  defense_number integer NOT NULL,
  critical_chance float NOT NULL,
  num_items_dropped smallint NOT NULL,
  min_xp_reward integer NOT NULL,
  max_xp_reward integer NOT NULL,
  min_gold_bounty integer NOT NULL,
  max_gold_bounty integer NOT NULL,
  min_itemdrop_value integer NOT NULL,
  max_itemdrop_value integer NOT NULL
);

CREATE TABLE fights_heroes (
  id SERIAL PRIMARY KEY,
  fight_id integer NOT NULL,
  heroes_id integer NOT NULL,
  won boolean,
  died boolean,
  initiator boolean
);

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  rarity item_type NOT NULL,
  req_id integer,
  name varchar(64) UNIQUE NOT NULL,
  description varchar(128),
  equip_slot equip_slot,
  sellable boolean NOT NULL,
  tradable boolean NOT NULL,
  stack_size smallint NOT NULL,
  weight float NOT NULL,
  price integer NOT NULL
);

CREATE TABLE heroes_achievements (
  id SERIAL PRIMARY KEY,
  hero_id integer NOT NULL,
  achievement_id integer NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE item_modifiers (
  id SERIAL PRIMARY KEY,
  name varchar(20) NOT NULL,
  player_item_id integer NOT NULL,
  modifies varchar(32) NOT NULL,
  modifier_type_flat boolean NOT NULL,
  flat_value integer NOT NULL,
  percent_value float NOT NULL
);

CREATE TABLE weapon (
  id SERIAL PRIMARY KEY,
  item_id integer NOT NULL,
  damage integer NOT NULL,
  weapon_type weapon_types NOT NULL,
  two_wielded boolean,
  attack_up integer,
  critical_chance float,
  critical_percent smallint,
  attack_speed integer,
  splash_damage boolean,
  weapon_range smallint,
  damage_type damage_types
);

CREATE TABLE armor (
  id SERIAL PRIMARY KEY,
  item_id integer NOT NULL,
  attack_up integer,
  critical_up integer,
  mana_up integer,
  defense_up integer
);

CREATE TABLE requirements (
  id SERIAL PRIMARY KEY,
  level_req integer NOT NULL,
  strength_req smallint,
  agility_req smallint,
  intelligence_req smallint,
  luck_req smallint,
  charisma_req smallint,
  perception_req smallint,
  persuasion_req smallint
);

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  team_name varchar(32) NOT NULL CHECK(LENGTH(teams.team_name) > 5),
  team_small_name varchar(5) NOT NULL,
  leader_id integer NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE team_members (
  id SERIAL PRIMARY KEY,
  team_id integer NOT NULL,
  hero_id integer NOT NULL,
  can_invite boolean NOT NULL,
  joined_at timestamp NOT NULL
);

CREATE TABLE team_invites (
  id SERIAL PRIMARY KEY,
  team_id integer NOT NULL,
  hero_id integer NOT NULL,
  sender_id integer NOT NULL,
  request_time timestamp NOT NULL,
  blocked boolean
);

CREATE TABLE login_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id integer NOT NULL,
  login_time timestamp NOT NULL,
  login_data text
);

CREATE TABLE user_relationship (
  id SERIAL PRIMARY KEY,
  user1_id integer NOT NULL,
  user2_id integer NOT NULL,
  status relationships NOT NULL
);

CREATE TABLE classes (
  id smallint UNIQUE PRIMARY KEY,
  name varchar(20) NOT NULL,
  description text NOT NULL,
  healt_per_level integer,
  mana_per_level integer,
  attack_per_level integer,
  defense_per_level integer
);

CREATE TABLE loot_drop (
  id SERIAL PRIMARY KEY,
  npc_id integer NOT NULL,
  item_id integer NOT NULL,
  drop_chance float NOT NULL,
  common_chance float NOT NULL,
  rare_chance float NOT NULL,
  epic_chance float NOT NULL,
  legendary_chance float NOT NULL,
  min_count smallint NOT NULL,
  max_count smallint NOT NULL
);

CREATE TABLE races (
  id SERIAL PRIMARY KEY,
  language varchar(10) NOT NULL,
  name varchar(20) NOT NULL UNIQUE,
  lore text NOT NULL,
  start_city_name text NOT NULL,
  racial_ability integer NOT NULL,
  special_buffs text,
  base_strength smallint,
  base_agility smallint,
  base_intelligence smallint,
  base_luck smallint,
  base_charisma smallint,
  base_perception smallint,
  base_persuasion smallint
);

CREATE TABLE fights (
  id SERIAL PRIMARY KEY,
  map_id integer NOT NULL,
  xp_reward integer NOT NULL,
  gold_reward integer NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE combat_logs (
  id SERIAL PRIMARY KEY,
  round_number smallint NOT NULL,
  turn_number smallint NOT NULL,
  fight_id integer NOT NULL,
  user_attacker_id integer NOT NULL,
  user_defender_id integer NOT NULL,
  npc_attacker_id integer NOT NULL,
  npc_defender_id integer NOT NULL,
  damage_dealt integer,
  defender_health integer,
  attacker_weapon_id integer NOT NULL,
  defender_defense_number integer,
  attacker_ability_used integer,
  defender_ability_used integer,
  attacker_status_effect status_effects,
  defender_died boolean NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE hero_levels (
  level SERIAL PRIMARY KEY,
  total_xp integer NOT NULL,
  level_rewards text,
  perk_points smallint NOT NULL,
  ability_points smallint NOT NULL
);

CREATE TABLE heroes (
  id SERIAL PRIMARY KEY,
  user_id integer NOT NULL,
  level integer NOT NULL,
  class_id smallint NOT NULL,
  gender gender NOT NULL,
  experience_points integer NOT NULL,
  health_points integer NOT NULL,
  mana integer NOT NULL,
  attack_number integer NOT NULL,
  defense_number integer NOT NULL,
  world_level smallint,
  cash_money integer,
  bank_money integer,
  title_id integer,
  race_id smallint,
  created_at timestamp NOT NULL
);

CREATE TABLE external_identity (
  id SERIAL PRIMARY KEY,
  user_id integer,
  external_user_id integer NOT NULL,
  oauth_provider varchar(20) NOT NULL,
  acccess_token varchar(40) NOT NULL,
  refresh_token varchar(40) NOT NULL,
  expiry_date timestamp NOT NULL
);

CREATE TABLE unique_mobs_killed (
  id SERIAL PRIMARY KEY,
  hero_id integer NOT NULL,
  mob_id integer NOT NULL
);

CREATE TABLE npc_hero_nicknames (
  id SERIAL PRIMARY KEY,
  ally_title varchar(32),
  enemy_title varchar(32),
  noble_title varchar(32),
  old_language_title varchar(32)
);

CREATE TABLE player_items (
  id SERIAL PRIMARY KEY,
  equipped boolean NOT NULL,
  hero_id integer NOT NULL,
  item_id integer NOT NULL
);

CREATE TABLE consumables (
  id SERIAL PRIMARY KEY,
  item_id integer NOT NULL,
  health_regen_up float,
  status_effect status_effects,
  turn_duration smallint,
  mana_regen_up float,
  health_flat_up integer,
  mana_flat_up integer
);

CREATE TABLE skills (
  hero_id SERIAL PRIMARY KEY NOT NULL,
  crafting smallint DEFAULT 0,
  archery smallint DEFAULT 0,
  mining smallint DEFAULT 0,
  smithing smallint DEFAULT 0,
  fishing smallint DEFAULT 0,
  cooking smallint DEFAULT 0,
  runecrafting smallint DEFAULT 0,
  enchanting smallint DEFAULT 0,
  summoning smallint DEFAULT 0
);

CREATE TABLE perks (
  hero_id SERIAL PRIMARY KEY NOT NULL,
  strenth smallint,
  agility smallint,
  intelligence smallint,
  luck smallint,
  charisma smallint,
  perception smallint,
  persuasion smallint
);

CREATE TABLE hero_statistics (
  hero_id integer PRIMARY KEY NOT NULL,
  npcs_slain integer DEFAULT 0,
  gold_spent integer DEFAULT 0,
  levels_cleared smallint DEFAULT 0,
  bosses_slain integer DEFAULT 0,
  game_finished boolean,
  players_slain integer DEFAULT 0,
  deaths integer DEFAULT 0
);

CREATE TABLE accessories (
  id SERIAL PRIMARY KEY,
  type varchar(20),
  item_id integer NOT NULL,
  strength_up smallint,
  agility_up smallint,
  intelligence_up smallint,
  luck_up smallint,
  charisma_up smallint,
  perception_up smallint,
  persuasion_up smallint
);

CREATE TABLE npc_fight (
  id SERIAL PRIMARY KEY,
  fight_id integer NOT NULL,
  non_playable_characters_id integer NOT NULL
);

CREATE TABLE achievements (
  id SERIAL PRIMARY KEY,
  requirements text NOT NULL,
  name varchar(64) UNIQUE NOT NULL,
  description text
);

CREATE TABLE quests_player_relationship (
  id SERIAL PRIMARY KEY,
  completed quest_status NOT NULL,
  hero_id integer NOT NULL,
  quest_id integer NOT NULL
);

CREATE TABLE quests (
  id SERIAL PRIMARY KEY,
  name varchar(64) UNIQUE NOT NULL,
  lvl_requirement integer NOT NULL,
  map_requirement integer NOT NULL,
  description text,
  quest_giver integer NOT NULL,
  xp_reward integer NOT NULL,
  gold_reward integer NOT NULL
);

CREATE TABLE quest_item_rewards (
  id SERIAL PRIMARY KEY,
  quest_id integer NOT NULL,
  item_id integer NOT NULL
);

ALTER TABLE friend_requests ADD FOREIGN KEY (sender_id) REFERENCES users (id);

ALTER TABLE friend_requests ADD FOREIGN KEY (receiver_id) REFERENCES users (id);

ALTER TABLE messages ADD FOREIGN KEY (sender) REFERENCES room_participants (id);

ALTER TABLE room_participants ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE room_participants ADD FOREIGN KEY (room_id) REFERENCES rooms (id);

ALTER TABLE map_objects ADD FOREIGN KEY (map_id) REFERENCES map (id);

ALTER TABLE map_objects ADD FOREIGN KEY (object_id) REFERENCES objects (id);

ALTER TABLE abilities_requirement ADD FOREIGN KEY (ability_id) REFERENCES abilities (id);

ALTER TABLE abilities_requirement ADD FOREIGN KEY (required_ability_id) REFERENCES abilities (id);

ALTER TABLE abilities_requirement ADD FOREIGN KEY (class_id) REFERENCES classes (id);

ALTER TABLE heroes_abilities ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE heroes_abilities ADD FOREIGN KEY (ability_id) REFERENCES abilities (id);

ALTER TABLE npc_spawn_rules ADD FOREIGN KEY (map_id) REFERENCES map (id);

ALTER TABLE npc_spawn_rules ADD FOREIGN KEY (npc_id) REFERENCES non_playable_characters (id);

ALTER TABLE heroes ADD FOREIGN KEY (id) REFERENCES players_locations (player_id);

ALTER TABLE players_locations ADD FOREIGN KEY (map_id) REFERENCES map (id);

ALTER TABLE npc_spells ADD FOREIGN KEY (npc_id) REFERENCES non_playable_characters (id);

ALTER TABLE npc_spells ADD FOREIGN KEY (ability_id) REFERENCES abilities (id);

ALTER TABLE fights_heroes ADD FOREIGN KEY (fight_id) REFERENCES fights (id);

ALTER TABLE fights_heroes ADD FOREIGN KEY (heroes_id) REFERENCES heroes (id);

ALTER TABLE items ADD FOREIGN KEY (req_id) REFERENCES requirements (id);

ALTER TABLE heroes_achievements ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE heroes_achievements ADD FOREIGN KEY (achievement_id) REFERENCES achievements (id);

ALTER TABLE item_modifiers ADD FOREIGN KEY (player_item_id) REFERENCES player_items (id);

ALTER TABLE weapon ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE armor ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE teams ADD FOREIGN KEY (leader_id) REFERENCES heroes (id);

ALTER TABLE team_members ADD FOREIGN KEY (team_id) REFERENCES teams (team_id);

ALTER TABLE team_members ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE team_invites ADD FOREIGN KEY (team_id) REFERENCES teams (team_id);

ALTER TABLE team_invites ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE team_invites ADD FOREIGN KEY (sender_id) REFERENCES heroes (id);

ALTER TABLE login_logs ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE user_relationship ADD FOREIGN KEY (user1_id) REFERENCES users (id);

ALTER TABLE user_relationship ADD FOREIGN KEY (user2_id) REFERENCES users (id);

ALTER TABLE loot_drop ADD FOREIGN KEY (npc_id) REFERENCES non_playable_characters (id);

ALTER TABLE loot_drop ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE races ADD FOREIGN KEY (racial_ability) REFERENCES abilities (id);

ALTER TABLE fights ADD FOREIGN KEY (map_id) REFERENCES map (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (fight_id) REFERENCES fights (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (user_attacker_id) REFERENCES heroes (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (user_defender_id) REFERENCES heroes (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (npc_attacker_id) REFERENCES npc_fight (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (npc_defender_id) REFERENCES npc_fight (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (attacker_weapon_id) REFERENCES weapon (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (attacker_ability_used) REFERENCES abilities (id);

ALTER TABLE combat_logs ADD FOREIGN KEY (defender_ability_used) REFERENCES abilities (id);

ALTER TABLE heroes ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE heroes ADD FOREIGN KEY (level) REFERENCES hero_levels (level);

ALTER TABLE heroes ADD FOREIGN KEY (class_id) REFERENCES classes (id);

ALTER TABLE heroes ADD FOREIGN KEY (title_id) REFERENCES npc_hero_nicknames (id);

ALTER TABLE heroes ADD FOREIGN KEY (race_id) REFERENCES races (id);

ALTER TABLE external_identity ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE unique_mobs_killed ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE unique_mobs_killed ADD FOREIGN KEY (mob_id) REFERENCES non_playable_characters (id);

ALTER TABLE player_items ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE player_items ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE consumables ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE skills ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE perks ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE hero_statistics ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE accessories ADD FOREIGN KEY (item_id) REFERENCES items (id);

ALTER TABLE npc_fight ADD FOREIGN KEY (fight_id) REFERENCES fights (id);

ALTER TABLE npc_fight ADD FOREIGN KEY (non_playable_characters_id) REFERENCES non_playable_characters (id);

ALTER TABLE quests_player_relationship ADD FOREIGN KEY (hero_id) REFERENCES heroes (id);

ALTER TABLE quests_player_relationship ADD FOREIGN KEY (quest_id) REFERENCES quests (id);

ALTER TABLE quests ADD FOREIGN KEY (map_requirement) REFERENCES map (id);

ALTER TABLE quests ADD FOREIGN KEY (quest_giver) REFERENCES non_playable_characters (id);

ALTER TABLE quest_item_rewards ADD FOREIGN KEY (quest_id) REFERENCES quests (id);

ALTER TABLE quest_item_rewards ADD FOREIGN KEY (item_id) REFERENCES items (id);

COMMENT ON COLUMN rooms.room_type IS 'trade, LFG, idk';

COMMENT ON COLUMN abilities.spell_type IS 'pure, magical, physical';

COMMENT ON COLUMN abilities.status_effect IS 'slow, stun, damage over time, idk man';

COMMENT ON COLUMN items.req_id IS 'nie všetky itemy maju obmedzenia';

COMMENT ON COLUMN items.equip_slot IS 'null pre consumables';

COMMENT ON COLUMN item_modifiers.modifier_type_flat IS 'bud flat increase alebo percento';

COMMENT ON COLUMN login_logs.login_data IS 'ip address, port, browser, location';

COMMENT ON COLUMN heroes.world_level IS 'najvyssi herny level na ktorom sa postava nachadza';

COMMENT ON COLUMN npc_hero_nicknames.ally_title IS 'white wolf';

COMMENT ON COLUMN npc_hero_nicknames.enemy_title IS 'butcher of blaviken';

COMMENT ON COLUMN npc_hero_nicknames.noble_title IS 'ravix of fourhorn';

COMMENT ON COLUMN npc_hero_nicknames.old_language_title IS 'Gwynbleidd';

CREATE TABLE "users" (
  "id" BIGSERIAL UNIQUE PRIMARY KEY,
  "username" varchar(32) NOT NULL,
  "nickname" varchar(50) NOT NULL,
  "realname" varchar(64) NOT NULL,
  "email_address" varchar(320),
  "password_hash" varchar(32),
  "banned" boolean,
  "newsletter" boolean,
  "signed_in_at" timestamp,
  "last_login" timestamp
);

CREATE TABLE "friend_requests" (
  "id" bigint UNIQUE PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "friend_id" bigint NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE "map" (
  "id" integer PRIMARY KEY,
  "name" varchar(64) NOT NULL,
  "x_size" integer NOT NULL,
  "y_size" integer NOT NULL
);

CREATE TABLE "messages" (
  "id" BIGSERIAL UNIQUE PRIMARY KEY,
  "sender" bigint NOT NULL,
  "room_id" bigint NOT NULL,
  "message_data" text NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE "rooms" (
  "id" BIGSERIAL UNIQUE PRIMARY KEY,
  "name" varchar(20),
  "room_type" varchar(10)
);

CREATE TABLE "room_participants" (
  "id" SERIAL UNIQUE PRIMARY KEY,
  "user_id" bigint,
  "room_id" bigint
);

CREATE TABLE "map_objects" (
  "id" bigint PRIMARY KEY,
  "map_id" integer,
  "object_id" bigint,
  "x_pos" integer,
  "y_pos" integer
);

CREATE TABLE "abilities" (
  "id" integer PRIMARY KEY,
  "name" varchar(20),
  "description" varchar(100),
  "damage" integer,
  "heal" integer,
  "spell_type" varchar(10),
  "splash_damage" boolean,
  "status_effect" varchar(10),
  "status_duration" integer,
  "mana_cost" integer,
  "health_cost" integer
);

CREATE TABLE "abilities_requirement" (
  "id" integer PRIMARY KEY,
  "ability_id" integer,
  "required_ability_id" integer
);

CREATE TABLE "heroes_abilities" (
  "id" bigint PRIMARY KEY,
  "hero_id" bigint,
  "ability_id" bigint
);

CREATE TABLE "objects" (
  "id" bigint PRIMARY KEY,
  "name" varchar(64),
  "object_filename" bytea
);

CREATE TABLE "npc_spawn_rules" (
  "id" BIGSERIAL PRIMARY KEY,
  "map_id" integer,
  "x_pos" integer,
  "y_pos" integer,
  "z_level" integer,
  "dead_time" integer,
  "isSpawned" boolean,
  "group_size" smallint,
  "isRespawnable" boolean,
  "npc_id" integer,
  "item_droprate_factor" float,
  "gold_bounty_factor" float,
  "description" text
);

CREATE TABLE "player_location" (
  "id" bigint PRIMARY KEY,
  "player_id" bigint,
  "map_id" integer,
  "x_pos" integer,
  "y_pos" integer
);

CREATE TABLE "non_playable_characters" (
  "id" BIGSERIAL PRIMARY KEY,
  "level" integer,
  "level_range" smallint,
  "name" varchar(50),
  "hostile" boolean,
  "unique" boolean,
  "health_points" integer,
  "mana" integer,
  "attack_number" integer,
  "defense_number" integer,
  "critical_chance" float,
  "num_items_dropped" smallint,
  "min_xp_reward" integer,
  "max_xp_reward" integer,
  "min_gold_bounty" integer,
  "max_gold_bounty" integer,
  "min_itemdrop_value" integer,
  "max_itemdrop_value" integer
);

CREATE TABLE "fights_heroes" (
  "id" bigint PRIMARY KEY,
  "fight_id" bigint,
  "heroes_id" bigint,
  "died" boolean
);

CREATE TABLE "items" (
  "id" BIGSERIAL PRIMARY KEY,
  "rarity" varchar(10),
  "req_id" integer,
  "name" varchar(64),
  "description" varchar(128),
  "equip_slot" varchar(10),
  "type" varchar(16),
  "sellable" boolean,
  "tradable" boolean,
  "stack_size" smallint,
  "weight" float,
  "price" integer
);

CREATE TABLE "heroes_achievements" (
  "id" bigint PRIMARY KEY,
  "hero_id" bigint,
  "achievement_id" bigint,
  "created_at" timestamp
);

CREATE TABLE "item_modifiers" (
  "id" bigint PRIMARY KEY,
  "player_item_id" bigint,
  "modifies" varchar(32),
  "modifier_type_flat" boolean,
  "flat_value" integer,
  "percent_value" float
);

CREATE TABLE "weapon" (
  "id" bigint PRIMARY KEY,
  "item_id" bigint,
  "weapon_type" varchar(20),
  "two_wielded" boolean,
  "attack_up" integer,
  "critical_chance" float,
  "critical_percent" smallint,
  "attack_speed" integer,
  "splash_damage" boolean,
  "weapon_range" smallint,
  "damage_type" varchar(20)
);

CREATE TABLE "armor" (
  "id" bigint PRIMARY KEY,
  "item_id" bigint,
  "attack_up" integer,
  "critical_up" integer,
  "mana_up" integer,
  "defense_up" integer
);

CREATE TABLE "requirements" (
  "id" SERIAL PRIMARY KEY,
  "level_req" integer,
  "strength_req" smallint,
  "agility_req" smallint,
  "intelligence_req" smallint,
  "luck_req" smallint,
  "charisma_req" smallint,
  "perception_req" smallint,
  "persuasion_req" smallint
);

CREATE TABLE "teams" (
  "team_id" BIGSERIAL PRIMARY KEY,
  "team_name" varchar(32),
  "team_small_name" varchar(5),
  "leader_id" bigint,
  "created_at" timestamp
);

CREATE TABLE "team_members" (
  "id" bigint PRIMARY KEY,
  "team_id" bigint,
  "hero_id" bigint,
  "can_invite" boolean,
  "joined_at" timestamp
);

CREATE TABLE "team_invites" (
  "id" bigint PRIMARY KEY,
  "team_id" bigint,
  "hero_id" bigint,
  "sender_id" bigint,
  "request_time" timestamp,
  "blocked" boolean
);

CREATE TABLE "user_permissions" (
  "id" SERIAL UNIQUE PRIMARY KEY,
  "user_id" bigint,
  "permission" varchar(10)
);

CREATE TABLE "login_logs" (
  "user_id" bigint PRIMARY KEY,
  "username" varchar(32),
  "login_time" timestamp,
  "login_data" text
);

CREATE TABLE "user_relationship" (
  "id" BIGSERIAL PRIMARY KEY,
  "user1_id" bigint,
  "user2_id" bigint,
  "status" smallint
);

CREATE TABLE "classes" (
  "id" smallint UNIQUE PRIMARY KEY,
  "name" varchar(20),
  "description" text,
  "healt_per_level" integer,
  "mana_per_level" integer,
  "attack_per_level" integer,
  "defense_per_level" integer
);

CREATE TABLE "loot_drop" (
  "id" BIGSERIAL PRIMARY KEY,
  "hero_world_level" smallint,
  "npc_id" bigint,
  "item_id" bigint,
  "item_name" varchar(32),
  "drop_chance" float,
  "common_chance" float,
  "rare_chance" float,
  "epic_chance" float,
  "legendary_chance" float,
  "min_count" smallint,
  "max_count" smallint
);

CREATE TABLE "races" (
  "id" SERIAL PRIMARY KEY,
  "language" varchar(10),
  "name" varchar(20),
  "lore" text,
  "start_city_name" text,
  "racial_ability" integer,
  "special_buffs" text,
  "base_strength" smallint,
  "base_agility" smallint,
  "base_intelligence" smallint,
  "base_luck" smallint,
  "base_charisma" smallint,
  "base_perception" smallint,
  "base_persuasion" smallint
);

CREATE TABLE "fights" (
  "id" bigint PRIMARY KEY,
  "map_id" integer,
  "won" boolean,
  "initiator" boolean,
  "xp_reward" integer,
  "gold_reward" integer,
  "created_at" timestamp
);

CREATE TABLE "combat_logs" (
  "id" bigint PRIMARY KEY,
  "round_number" smallint,
  "turn_number" smallint,
  "fight_id" bigint,
  "user_attacker_id" bigint,
  "user_defender_id" bigint,
  "npc_identificator" smallint,
  "npc_attacker_id" bigint,
  "npc_defender_id" bigint,
  "damage_dealt" integer,
  "defender_health" integer,
  "attacker_weapon_id" bigint,
  "defender_defense_number" bigint,
  "attacker_ability_used" integer,
  "defender_ability_used" integer,
  "attacker_status_effect" varchar(10),
  "defender_died" boolean,
  "created_at" timestamp
);

CREATE TABLE "hero_levels" (
  "level" SERIAL PRIMARY KEY,
  "total_xp" bigint,
  "level_rewards" text
);

CREATE TABLE "heroes" (
  "id" BIGSERIAL PRIMARY KEY,
  "user_id" bigint,
  "level" integer,
  "class_id" smallint,
  "gender" varchar(1),
  "experience_points" integer,
  "health_points" integer,
  "mana" integer,
  "attack_number" integer,
  "defense_number" integer,
  "world_level" smallint,
  "cash_money" bigint,
  "bank_money" bigint,
  "title_id" integer,
  "name" varchar(32),
  "race_id" smallint,
  "unique_mobs_killed_id" integer,
  "created_at" timestamp
);

CREATE TABLE "unique_mobs_killed" (
  "id" SERIAL PRIMARY KEY,
  "hero_id" bigint,
  "mob_id" bigint
);

CREATE TABLE "npc_hero_nicknames" (
  "id" SERIAL PRIMARY KEY,
  "ally_title" varchar(32),
  "enemy_title" varchar(32),
  "noble_title" varchar(32),
  "old_language_title" varchar(32)
);

CREATE TABLE "player_items" (
  "id" bigint PRIMARY KEY,
  "equipped" boolean,
  "hero_id" bigint,
  "item_id" bigint
);

CREATE TABLE "consumables" (
  "id" bigint PRIMARY KEY,
  "item_id" bigint,
  "health_regen_up" float,
  "mana_regen_up" float,
  "health_flat_up" integer,
  "mana_flat_up" integer
);

CREATE TABLE "skills" (
  "hero_id" BIGSERIAL PRIMARY KEY,
  "crafting" smallint,
  "archery" smallint,
  "mining" smallint,
  "smithing" smallint,
  "fishing" smallint,
  "cooking" smallint,
  "runecrafting" smallint,
  "enchanting" smallint,
  "summoning" smallint
);

CREATE TABLE "perks" (
  "hero_id" BIGSERIAL PRIMARY KEY,
  "strenth" smallint,
  "agility" smallint,
  "intelligence" smallint,
  "luck" smallint,
  "charisma" smallint,
  "perception" smallint,
  "persuasion" smallint
);

CREATE TABLE "hero_statistics" (
  "hero_id" integer PRIMARY KEY,
  "npcs_slain" bigint,
  "gold_spent" bigint,
  "total_playtime" bigint,
  "levels_cleared" smallint,
  "bosses_slain" integer,
  "game_finished" boolean,
  "players_slain" integer,
  "deaths" integer
);

CREATE TABLE "accessories" (
  "id" bigint PRIMARY KEY,
  "type" varchar(20),
  "item_id" bigint,
  "strength_up" smallint,
  "agility_up" smallint,
  "intelligence_up" smallint,
  "luck_up" smallint,
  "charisma_up" smallint,
  "perception_up" smallint,
  "persuasion_up" smallint
);

CREATE TABLE "npc_fight" (
  "id" bigint PRIMARY KEY,
  "fight_id" bigint,
  "non_playable_characters_id" bigint
);

CREATE TABLE "achievements" (
  "id" SERIAL PRIMARY KEY,
  "requirements" text,
  "name" varchar(64),
  "description" text
);

CREATE TABLE "quests_player_relationship" (
  "id" BIGSERIAL PRIMARY KEY,
  "completed" boolean,
  "hero_id" bigint,
  "quest_id" bigint
);

CREATE TABLE "quests" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(64),
  "main_quest" boolean,
  "lvl_requirement" integer,
  "map_requirement" integer,
  "description" text,
  "quest_giver" bigint,
  "xp_reward" integer,
  "preceeding_quest_id" integer,
  "gold_reward" integer
);

CREATE TABLE "quest_item_rewards" (
  "id" bigint,
  "quest_id" integer,
  "item_id" bigint
);

ALTER TABLE "friend_requests" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "friend_requests" ADD FOREIGN KEY ("friend_id") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");

ALTER TABLE "room_participants" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "room_participants" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");

ALTER TABLE "map_objects" ADD FOREIGN KEY ("map_id") REFERENCES "map" ("id");

ALTER TABLE "map_objects" ADD FOREIGN KEY ("object_id") REFERENCES "objects" ("id");

ALTER TABLE "abilities_requirement" ADD FOREIGN KEY ("ability_id") REFERENCES "abilities" ("id");

ALTER TABLE "abilities_requirement" ADD FOREIGN KEY ("required_ability_id") REFERENCES "abilities" ("id");

ALTER TABLE "heroes_abilities" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "heroes_abilities" ADD FOREIGN KEY ("ability_id") REFERENCES "abilities" ("id");

ALTER TABLE "npc_spawn_rules" ADD FOREIGN KEY ("map_id") REFERENCES "map" ("id");

ALTER TABLE "npc_spawn_rules" ADD FOREIGN KEY ("npc_id") REFERENCES "non_playable_characters" ("id");

ALTER TABLE "player_location" ADD FOREIGN KEY ("player_id") REFERENCES "heroes" ("id");

ALTER TABLE "player_location" ADD FOREIGN KEY ("map_id") REFERENCES "map" ("id");

ALTER TABLE "fights_heroes" ADD FOREIGN KEY ("fight_id") REFERENCES "fights" ("id");

ALTER TABLE "fights_heroes" ADD FOREIGN KEY ("heroes_id") REFERENCES "heroes" ("id");

ALTER TABLE "items" ADD FOREIGN KEY ("req_id") REFERENCES "requirements" ("id");

ALTER TABLE "heroes_achievements" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "heroes_achievements" ADD FOREIGN KEY ("achievement_id") REFERENCES "achievements" ("id");

ALTER TABLE "item_modifiers" ADD FOREIGN KEY ("player_item_id") REFERENCES "player_items" ("id");

ALTER TABLE "weapon" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "armor" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "teams" ADD FOREIGN KEY ("leader_id") REFERENCES "users" ("id");

ALTER TABLE "team_members" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("team_id");

ALTER TABLE "team_members" ADD FOREIGN KEY ("hero_id") REFERENCES "users" ("id");

ALTER TABLE "team_invites" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("team_id");

ALTER TABLE "team_invites" ADD FOREIGN KEY ("hero_id") REFERENCES "users" ("id");

ALTER TABLE "team_invites" ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("id");

ALTER TABLE "user_permissions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "login_logs" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_relationship" ADD FOREIGN KEY ("user1_id") REFERENCES "users" ("id");

ALTER TABLE "user_relationship" ADD FOREIGN KEY ("user2_id") REFERENCES "users" ("id");

ALTER TABLE "loot_drop" ADD FOREIGN KEY ("npc_id") REFERENCES "non_playable_characters" ("id");

ALTER TABLE "loot_drop" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "races" ADD FOREIGN KEY ("racial_ability") REFERENCES "abilities" ("id");

ALTER TABLE "fights" ADD FOREIGN KEY ("map_id") REFERENCES "map" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("fight_id") REFERENCES "fights" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("user_attacker_id") REFERENCES "heroes" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("user_defender_id") REFERENCES "heroes" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("npc_attacker_id") REFERENCES "npc_fight" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("npc_defender_id") REFERENCES "npc_fight" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("attacker_weapon_id") REFERENCES "weapon" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("attacker_ability_used") REFERENCES "abilities" ("id");

ALTER TABLE "combat_logs" ADD FOREIGN KEY ("defender_ability_used") REFERENCES "abilities" ("id");

ALTER TABLE "heroes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "heroes" ADD FOREIGN KEY ("level") REFERENCES "hero_levels" ("level");

ALTER TABLE "heroes" ADD FOREIGN KEY ("class_id") REFERENCES "classes" ("id");

ALTER TABLE "heroes" ADD FOREIGN KEY ("title_id") REFERENCES "npc_hero_nicknames" ("id");

ALTER TABLE "heroes" ADD FOREIGN KEY ("race_id") REFERENCES "races" ("id");

ALTER TABLE "unique_mobs_killed" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "unique_mobs_killed" ADD FOREIGN KEY ("mob_id") REFERENCES "non_playable_characters" ("id");

ALTER TABLE "player_items" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "player_items" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "consumables" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "skills" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "perks" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "hero_statistics" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "accessories" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

ALTER TABLE "npc_fight" ADD FOREIGN KEY ("fight_id") REFERENCES "fights" ("id");

ALTER TABLE "npc_fight" ADD FOREIGN KEY ("non_playable_characters_id") REFERENCES "non_playable_characters" ("id");

ALTER TABLE "quests_player_relationship" ADD FOREIGN KEY ("hero_id") REFERENCES "heroes" ("id");

ALTER TABLE "quests_player_relationship" ADD FOREIGN KEY ("quest_id") REFERENCES "quests" ("id");

ALTER TABLE "quests" ADD FOREIGN KEY ("quest_giver") REFERENCES "non_playable_characters" ("id");

ALTER TABLE "quests" ADD FOREIGN KEY ("preceeding_quest_id") REFERENCES "quests" ("id");

ALTER TABLE "quest_item_rewards" ADD FOREIGN KEY ("quest_id") REFERENCES "quests" ("id");

ALTER TABLE "quest_item_rewards" ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id");

COMMENT ON COLUMN "rooms"."room_type" IS 'trade, LFG, idk';

COMMENT ON COLUMN "abilities"."spell_type" IS 'pure, magical, physical';

COMMENT ON COLUMN "abilities"."status_effect" IS 'slow, stun, damage over time, idk man';

COMMENT ON COLUMN "items"."type" IS 'weapon, armor, consumable,material';

COMMENT ON COLUMN "item_modifiers"."modifier_type_flat" IS 'bud flat increase alebo percento';

COMMENT ON COLUMN "login_logs"."login_data" IS 'ip address, port, browser, location';

COMMENT ON COLUMN "user_relationship"."status" IS '1: friends, 2: ignored, 3: blocked';

COMMENT ON COLUMN "heroes"."world_level" IS 'najvyssi herny level na ktorom sa postava nachadza';

COMMENT ON COLUMN "npc_hero_nicknames"."ally_title" IS 'white wolf';

COMMENT ON COLUMN "npc_hero_nicknames"."enemy_title" IS 'butcher of blaviken';

COMMENT ON COLUMN "npc_hero_nicknames"."noble_title" IS 'ravix of fourhorn';

COMMENT ON COLUMN "npc_hero_nicknames"."old_language_title" IS 'Gwynbleidd';

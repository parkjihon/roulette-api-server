CREATE DATABASE IF NOT EXISTS crescent_roulette_db;
use crescent_roulette_db;

-- 프로모션(이벤트) 정보
CREATE TABLE IF NOT EXISTS `promotion` (
  `promotion_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  -- `voucher_id` bigint unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0, -- 진행 중/일시 중지 여부
  `is_whitelisted` tinyint(1) NOT NULL DEFAULT 0, -- 프론트에서 보여줄지 여부
  `voucher_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL, -- 상품 이름
  `voucher_exchange_ratio_0` int unsigned NOT NULL default 1,
  `voucher_exchange_ratio_1` int unsigned NOT NULL default 1,
  `voucher_total_supply` int NOT NULL DEFAULT 0,
  `voucher_remaining_qty` int NOT NULL DEFAULT 0,
  `promotion_start_at` timestamp,
  `promotion_end_at` timestamp,
  `claim_start_at` timestamp,
  `claim_end_at` timestamp,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 유저 테이블
CREATE TABLE IF NOT EXISTS `account` (
  `uid` bigint unsigned NOT NULL AUTO_INCREMENT,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket_amount` int NOT NULL DEFAULT 0,
  `admin_memo` tinytext COLLATE utf8mb4_unicode_ci,
  `type` int NOT NULL DEFAULT 0,
  `created_at` timestamp,
  `updated_at` timestamp,
  `last_login_at` timestamp,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `game_order` (
  `order_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `promotion_id` bigint unsigned NOT NULL,
  `game_id` bigint unsigned NOT NULL,
  `is_win` tinyint(1) NOT NULL DEFAULT 0,
  -- status: 1(진행중) 2(꽝으로인한종료) 3(클레임전) 4(클레임중) 5(클레임성공) 6(클레임실패) 7(취소)
  `status` int NOT NULL DEFAULT 1,
  `used_ticket_qty` int NOT NULL DEFAULT '0',
  `started_at` timestamp,
  `claimed_at` timestamp,
  `claim_finished_at` timestamp,
  `prize_id` int,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 상품의 종류 ex) cre, bcre, 10%수수료쿠폰, atom, nft 등
CREATE TABLE IF NOT EXISTS `prize_type` (
  `prize_type_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL, -- 상품 이름
  `type` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL, -- cre (name 과 중복인지 애매함)
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`prize_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 상품 분배 계획 풀
CREATE TABLE IF NOT EXISTS `distribution_pool` (
  `dist_pool_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` bigint unsigned NOT NULL,
  `prize_type_id` bigint unsigned NOT NULL,
  `total_supply` int NOT NULL DEFAULT 0,
  `remaining_qty` int NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`dist_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 프로모션 내 상품 리스트
CREATE TABLE IF NOT EXISTS `prize` (
  `prize_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `dist_pool_id` bigint unsigned NOT NULL,
  `promotion_id` bigint unsigned NOT NULL, -- option
  `prize_type_id` bigint unsigned NOT NULL, -- option
  `amount` bigint NOT NULL DEFAULT 1,  -- 100개
  `odds` decimal(3,3) NOT NULL,
  `win_cnt` int unsigned NOT NULL DEFAULT 0,
  `win_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_daily_win_limit` int,
  `max_total_win_limit` int,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`prize_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- temp: promotion 으로 merge 됨
CREATE TABLE IF NOT EXISTS `temp_voucher` (
  `voucher_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` bigint unsigned NOT NULL,
  `voucher_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL, -- 상품 이름
  `voucher_exchange_ratio_0` int unsigned NOT NULL default 1,
  `voucher_exchange_ratio_1` int unsigned NOT NULL default 1,
  `voucher_total_supply` int NOT NULL DEFAULT 0,
  `voucher_remaining_qty` int NOT NULL DEFAULT 0,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 유저 별 바우처 보유량
CREATE TABLE IF NOT EXISTS `user_voucher_balance` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `promotion_id` bigint unsigned NOT NULL, -- 프로모션:바우처 1:1 매핑이 아니라면 voucher_id
  `current_amount` bigint NOT NULL,
  `total_recevied_amount` bigint NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`id`),
  UNIQUE KEY `addr_voucher` (`addr`, `promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `game_type` (
  `game_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0, -- 진행 중/일시 중지 여부
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- voucher 전송 히스토리
CREATE TABLE IF NOT EXISTS `voucher_send_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned,
  `recipient_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  -- `voucher_id` 는 없어짐
  `promotion_id` bigint unsigned NOT NULL, -- 프로모션:바우처 1:1 매핑이 아니라면 voucher_id
  `amount` bigint NOT NULL,
  `sent_at` timestamp,
  -- 보낸 사람 정보
  PRIMARY KEY (`id`),
  KEY `recipient_addr` (`recipient_addr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- voucher -> ticket 교환 히스토리
CREATE TABLE IF NOT EXISTS `voucher_burn_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `promotion_id` bigint unsigned NOT NULL, -- 프로모션:바우처 1:1 매핑이 아니라면 voucher_id
  `burned_voucher_amount` bigint NOT NULL,
  `minted_ticket_amount` bigint NOT NULL,
  `burned_at` timestamp,
  PRIMARY KEY (`id`),
  KEY `addr` (`addr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 이벤트: 지갑 접속
-- 향후 고려사항: is_mobile, browser_type, ip, location...
CREATE TABLE IF NOT EXISTS `event_wallet_conn` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `addr_type` int NOT NULL DEFAULT 0,
  `promotion_id` bigint NOT NULL DEFAULT 0,
  `created_at` timestamp,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 이벤트: 링크 클릭
CREATE TABLE IF NOT EXISTS `event_flip_link` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `type` int NOT NULL DEFAULT 0,
  `promotion_id` bigint NOT NULL DEFAULT 0,
  `created_at` timestamp,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

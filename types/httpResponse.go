package types

import (
	"time"
)

type ResGetPromotions struct {
	PromotionId            uint64     `json:"promotionId" db:"promotion_id"`
	Title 			           string    `json:"title" db:"title"`
	Desc 			             string    `json:"desc" db:"desc"`
	IsActive               bool      `json:"isActive" db:"is_active"`
	IsWhitelisted          bool      `json:"isWhitelisted" db:"is_whitelisted"`
	VoucherName 			     string    `json:"voucherName" db:"voucher_name"`
	VoucherExchangeRatio0  int       `json:"voucherExchangeRatio0"`
	VoucherExchangeRatio1  int       `json:"voucherExchangeRatio1"`
	VoucherTotalSupply     uint64    `json:"voucherTotalSupply" db:"voucher_total_supply"`
	VoucherRemainingQty    uint64    `json:"voucherRemainingQty" db:"voucher_remaining_qty"`
	PromotionStartAt       time.Time `json:"promotionStartAt" db:"promotion_start_at"`
	PromotionEndAt         time.Time `json:"promotionEndAt" db:"promotion_end_at"`
	ClaimStartAt           time.Time `json:"claimStartAt" db:"claim_start_at"`
	ClaimEndAt             time.Time `json:"claimEndAt" db:"claim_end_at"`
	CreatedAt              time.Time `json:"createdAt" db:"created_at"`
	UpdatedAt              time.Time `json:"updatedAt" db:"updated_at"`
	// ---------- additional
	ParticipantCnt         uint64    `json:"voucherReceivedUserCnt" db:"participant_cnt"`
	// status: not started / in progress / finished
	Status                 string `json:"status" db:"status"`
	DistributionPools      *[]PrizeDistPool `json:"distributionPools"`
}

type ResGetPromotion struct {
	PromotionId            uint64     `json:"promotionId" db:"promotion_id"`
	Title 			           string    `json:"title" db:"title"`
	Desc 			             string    `json:"desc" db:"desc"`
	IsActive               bool      `json:"isActive" db:"is_active"`
	IsWhitelisted          bool      `json:"isWhitelisted" db:"is_whitelisted"`
	VoucherName 			     string    `json:"voucherName" db:"voucher_name"`
	VoucherExchangeRatio0  int       `json:"voucherExchangeRatio0"`
	VoucherExchangeRatio1  int       `json:"voucherExchangeRatio1"`
	VoucherTotalSupply     uint64    `json:"voucherTotalSupply" db:"voucher_total_supply"`
	VoucherRemainingQty    uint64    `json:"voucherRemainingQty" db:"voucher_remaining_qty"`
	PromotionStartAt       time.Time `json:"promotionStartAt" db:"promotion_start_at"`
	PromotionEndAt         time.Time `json:"promotionEndAt" db:"promotion_end_at"`
	ClaimStartAt           time.Time `json:"claimStartAt" db:"claim_start_at"`
	ClaimEndAt             time.Time `json:"claimEndAt" db:"claim_end_at"`
	CreatedAt              time.Time `json:"createdAt" db:"created_at"`
	UpdatedAt              time.Time `json:"updatedAt" db:"updated_at"`
	// status: not started / in progress / finished
	ParticipantCnt         uint64    `json:"voucherReceivedUserCnt" db:"participant_cnt"`
	Status string `json:"status" db:"status"`
	DistributionPools      *[]PrizeDistPoolDetail `json:"distributionPools"`
	Summary                PromotionSummary `json:"promotionSummary"`
}
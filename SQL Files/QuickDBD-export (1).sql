-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "cardholder" (
    "cardholder_id" int   NOT NULL,
    "cardholder_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_cardholder" PRIMARY KEY (
        "cardholder_id"
     )
);

CREATE TABLE "credit_card" (
    "cardnumber" BIGINT   NOT NULL,
    "cardholder_id" int   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY (
        "cardnumber"
     )
);

CREATE TABLE "merchant" (
    "merchant_id" int   NOT NULL,
    "merchant_name" varchar(50)   NOT NULL,
    "category_id" int   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY (
        "merchant_id"
     )
);

CREATE TABLE "merchant_category" (
    "category_id" int   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "transactions" (
    "transation_id" int   NOT NULL,
    "transaction_date" date   NOT NULL,
    "amount" float   NOT NULL,
    "cardnumber" BIGINT   NOT NULL,
    "merchant_id" int   NOT NULL,
    CONSTRAINT "pk_transactions" PRIMARY KEY (
        "transation_id"
     )
);

ALTER TABLE "credit_card" ADD CONSTRAINT "fk_credit_card_cardholder_id" FOREIGN KEY("cardholder_id")
REFERENCES "cardholder" ("cardholder_id");

ALTER TABLE "merchant" ADD CONSTRAINT "fk_merchant_category_id" FOREIGN KEY("category_id")
REFERENCES "merchant_category" ("category_id");

ALTER TABLE "transactions" ADD CONSTRAINT "fk_transactions_cardnumber" FOREIGN KEY("cardnumber")
REFERENCES "credit_card" ("cardnumber");

ALTER TABLE "transactions" ADD CONSTRAINT "fk_transactions_merchant_id" FOREIGN KEY("merchant_id")
REFERENCES "merchant" ("merchant_id");


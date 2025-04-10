Welcome to your new dbt project!

# Installation

The following tutorial assumes you're already familiar with git and command line usage.

## Getting the code to your local machine
1. Fork this github repository into your local account

2. Copy it to your local machine: `git clone https://github.com/your_account_name/econ250_2025.git`



## gcloud authentication

To run queries from your command line, you'll first need to install `gcloud` utility.

Follow the instructions here: https://cloud.google.com/sdk/docs/install. After installation you should have `gcloud` command available for running in the terminal.

Now, try to authenticate with your **kse email** using the following command: 

```bash
gcloud auth application-default login \
  --scopes=https://www.googleapis.com/auth/bigquery,\
https://www.googleapis.com/auth/drive.readonly,\
https://www.googleapis.com/auth/iam.test,\
https://www.googleapis.com/auth/cloud-platform
```

Now, when you run the following commands something similar should be response: 

```bash
$ gcloud auth list

     Credentialed Accounts
ACTIVE  ACCOUNT
*       o_omelchenko@kse.org.ua

```
To set the active project, run the following: 

```bash
gcloud config set project econ250-2025
```


## venv and libraries
Prerequisites: having Python installed on your machine. 
Following instructions are for Linux or WSL; if you'd like to run Windows - please refer to the documentation below.

```bash

# change directory to the one you just copied from github
cd econ250_2025 

# create and activate venv
python3 -m venv env 
source env/bin/activate

pip install -r requirements.txt

```

If everything is installed correctly, you should run the following commands successfully: 


```
$ dbt --version

Core:
  - installed: 1.9.3
  - latest:    1.9.3 - Up to date!

Plugins:
  - bigquery: 1.9.1 - Up to date!
```


For more detailed reference, refer to the official documentation here: 
- https://docs.getdbt.com/docs/core/pip-install
- https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#local-oauth-gcloud-setup

## Adjusting the configuration

You'll need to specify your own dataset to save your models to. To do so, navigate to the `profiles.yml` in the root directory of the project, and replace `o_omelchenko` with your bigquery dataset name with which you have been working previously.




## Final check

Try running the following command:
- dbt run

If everything is set up well, you will see similar output: 

```log
❯ dbt run
01:18:56  Running with dbt=1.9.3
01:18:57  Registered adapter: bigquery=1.9.1
01:18:57  Found 2 models, 4 data tests, 491 macros
01:18:57  
01:18:57  Concurrency: 2 threads (target='dev')
01:18:57  
01:19:00  1 of 2 START sql table model o_omelchenko.my_first_dbt_model ................... [RUN]
01:19:04  1 of 2 OK created sql table model o_omelchenko.my_first_dbt_model .............. [CREATE TABLE (2.0 rows, 0 processed) in 4.44s]
01:19:04  2 of 2 START sql view model o_omelchenko.my_second_dbt_model ................... [RUN]
01:19:06  2 of 2 OK created sql view model o_omelchenko.my_second_dbt_model .............. [CREATE VIEW (0 processed) in 2.13s]
01:19:06  
01:19:06  Finished running 1 table model, 1 view model in 0 hours 0 minutes and 9.64 seconds (9.64s).
```

If you have any troubles with installation, please contact the course instructor (Oleh Omelchenko) in slack for assist.

## Explanation of part 4

So, I decided to use partition by order_purchase_timestamp because such partition is good for time-based analytics which are common in such datasets. I decided to cluster by customer_id because several rows might have same or similar ids so it makes easier for BigQuery to scan data.

## Final Project Overview

So this is my project where I'm analyzing brazilian e-commerce dataset.

As initial data, I have 7 source datasets:
- fp_customers - This dataset has information about the customer and its location. Use it to identify unique customers in the orders dataset and to find the orders delivery location.
- fp_orders_items - This dataset includes data about the items purchased within each order.
- fp_order_payments - This dataset includes data about the orders payment options.
- fp_orders - This is the core dataset. From each order you might find all other information.
- fp_products - This dataset includes data about the products sold by Olist.
- fp_sellers - This dataset includes data about the sellers that fulfilled orders made at Olist. Use it to find the seller location and to identify which seller fulfilled each product.
- fp_product_category_name_translation - Translates the product_category_name to english.

Next we have 7 staged models, most of them have additional derived columns:
- fp_stg_customers - Staging model for fp_customers; no derived columns
- fp_stg_order_items - Staging model for fp_order_items; Derived column: sum of price and shipping pric (freight_value)
- fp_stg_order_payments - Staging model for fp_order_payments; Derived column checks whether payment was made by credit card, which is the most popular payment method
- fp_stg_orders - Staging model for fp_orders; Derived column shows how long it takes from order being approved to being delivered to customer
- fp_stg_product_category_name_translation - Staging model for fp_product_category_name_translation; Derived column shows whether original and localized names are the same
- fp_stg_products - Staging model for fp_products; Derived column shows the volume of the product
- fp_stg_sellers - Staging model for fp_sellers, no derived columns

Next we have fp_sales full dataset which includes all of information about orders within one dataset

And the last type of models are Mart models. I decided to perform such analysis: order performance, payment analysis and product performance. They are located at respective files:
- fp_fct_order_performance_analysis - Monthly order performance analysis
- fp_fct_payment_analysis - Payment method trends, installment patterns and regional preferences analysis
- fp_fct_product_perfomance - Analysis of top performing product categories by region, price, or time period'

More detailed documentation is available with dbt docs serve
from pyspark.sql import SparkSession
from datetime import datetime, timedelta

cols = ['id', 'name', 'ingestion_date']
data = [(i, f'name {i}', datetime.now() - timedelta(days=i % 3))
        for i in range(100000)]

spark = SparkSession \
    .builder \
    .getOrCreate()

df = spark.createDataFrame(data, cols)

spark.sql('create or replace table local.db.example (id bigint, name string, ingestion_date date) using iceberg')
df.writeTo('local.db.example').partitionedBy('ingestion_date').append()

# Deux

Experiments

## Setup


```
docker compose up -d
tigerbeetle format --cluster=0 --replica=0 --replica-count=1 --development ./0_0.tigerbeetle
tigerbeetle start --addresses=3000 --development ./0_0.tigerbeetle
```


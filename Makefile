up: 
	docker compose up --build -d

format: 
	docker exec kinesis_aws python -m black -S --line-length 79 .

isort:
	docker exec kinesis_aws isort .


type:
	docker exec kinesis_aws mypy --ignore-missing-imports .


lint: 
	docker exec glue_aws flake8 .

 
ci: isort format type lint 


infra-init: 
	docker compose -f docker-compose.yaml run --rm terraform -chdir=./terraform init

infra-validate: 
	docker compose -f docker-compose.yaml run --rm terraform -chdir=./terraform validate

infra-plan: 
	docker compose -f docker-compose.yaml run --rm terraform -chdir=./terraform plan -out=vg-kinesis

infra-apply: 
	docker compose -f docker-compose.yaml run --rm terraform -chdir=./terraform apply "vg-kinesis"

producer:
	python ./producer/data_producer.py --amount 100

infra-down: 
	docker compose -f docker-compose.yaml run --rm terraform -chdir=./terraform destroy 

down: 
	docker compose down


.PHONY: build
build:
	@docker build -t spark .

run:
	@docker run --rm \
		-v ${PWD}/apps:/apps\
		-v ${PWD}/spark-defaults.conf:/opt/spark/conf/spark-defaults.conf:ro\
		--entrypoint ""\
		-ti spark bash

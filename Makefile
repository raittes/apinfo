build:
	docker build -t apinfo .

run:
	docker run --name apinfo --rm -v $(PWD):/apinfo -p 4567:4567 -it apinfo

kill:
	docker rm -f apinfo

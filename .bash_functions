#Local machine
create_enter_dir (){
	mkdir -p $1
	cd $1
}

copy_with_rsync (){
	FROM="$1"
	TO="$2"
	rsync -chavzP --stats --progress "$FROM" "&TO"	
}

#Docker
docker_compose_up (){
	FROM_FILE="${1:-local.yml}"
	docker-compose -f "$FROM_FILE" up
}

#Git
git_send_all (){
	COMMIT_MESSAGE="${1:-.}"
	REPO="${2:-origin}"
	BRANCH="${3:-master}"

	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push "$REPO" "$BRANCH"
}

git_all_in_web (){
	git_send_all;
	webprod
	git pull local "$BRANCH"
	git push origin "$BRANCH"
	git push github "$BRANCH"
	
}

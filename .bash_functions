#Local machine
create_new_alias (){
	NAME="$1"
	DO="$2"
	echo "alias $NAME='$DO'" >> $PWD/".bash_alias"
	echo "Alias $1 created, refreshing alias"
	ra
	echo "New alias ready"
}

delete_alias (){
	ALIAS="$1"
	sed -i "/\b\($ALIAS\)\b/d" $PWD/".bash_alias"
	echo "Alias $NAME deleted, refreshing alias"
	ra
	echo "Alias ready"
}

create_enter_dir (){
	mkdir -p $1
	cd $1
}

copy_with_rsync (){
	FROM="$1"
	TO="${2:-.}"
	rsync -chavzP --stats --progress "$FROM" "$TO"	
}

extract_tgz (){
	FILE="$1"
        TO="${2:-.}"
	tar -xzvf "$FILE" -C "$TO"
}

count_files_inside (){
	FOLDER="${1:-.}"
	ls "$FOLDER" | wc -l
}

#Venv
create_activate_enter_venv () {
	VENV_NAME="${1:-venv}"
	venv "$VENV_NAME"
	source "$VENV_NAME"/bin/activate;
	cd $PWD"/"$VENV_NAME
}

#Docker
docker_compose_up (){
        FROM_FILE="${1:-local.yml}"
        docker-compose -f "$FROM_FILE" up
}

docker_compose_run_django (){
	FROM_FILE="${1:-local.yml}"
        COMMAND="$2"
	docker-compose -f "$FROM_FILE" run --rm django python manage.py "$2"
}


#Git
current_git_branch() {
 ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
 return $ref
}

git_send_all (){
	COMMIT_MESSAGE="${1:-.}"
	REPO="${2:-origin}"
	BRANCH="${3:-None}"
	if ($BRANCH == 'None'){
		BRANCH = current_git_branch;
	}
	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push "$REPO" "$BRANCH"
}

git_all_in_web (){
	CURRENT_PATH=$PWD
	git_send_all;
	webprod
	git pull local "$BRANCH"
	git push origin "$BRANCH"
	git push github "$BRANCH"
	cd "$CURRENT_PATH"
}

#Django
delete_all_migrations () {
	find . -path "*/migrations/*.py"  -not -path "*/contrib/sites/migrations/*.py" -not -name "__init__.py" -delete
	find . -path "*/migrations/*.pyc"  -delete
}

run_django_tests () {
	TEST="$1"
	dtest "$TEST" --settings config.settings.test --keepdb
}

create_new_django_app () {
	APP_NAME="$1"
	manage startapp "$APP_NAME"
}

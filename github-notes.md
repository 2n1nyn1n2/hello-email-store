# verify github url is correct

	PATH_PARENT=$(basename "$PWD")
	PATH_GRANDPARENT=$(basename "$(dirname "$PWD")")
	echo "git url https://github.com/${PATH_GRANDPARENT}/${PATH_PARENT}.git"

# delete deployment logs

	PATH_PARENT=$(basename "$PWD")
	PATH_GRANDPARENT=$(basename "$(dirname "$PWD")")
	REPO="${PATH_GRANDPARENT}/${PATH_PARENT}"
	echo "git url https://github.com/${PATH_GRANDPARENT}/${PATH_PARENT}.git"

	for ID in $(gh api --method GET "/repos/$REPO/deployments?per_page=100" --jq '.[].id'); do
		gh api --method POST /repos/$REPO/deployments/$ID/statuses -f "state=inactive" > /dev/null 2>&1
		gh api --method DELETE /repos/$REPO/deployments/$ID > /dev/null 2>&1
		echo "Deleted deployment $ID"
	done

# publish to github

	PATH_PARENT=$(basename "$PWD")
	PATH_GRANDPARENT=$(basename "$(dirname "$PWD")")
	CURRENT_VERSION=v1.0.0
	rm -rf .git;
	git init;
	git checkout -b main;
	find . -name ".DS_Store" -depth -exec rm {} \;
	find . -exec touch {} \;
	git add .;
	git commit -m "checkpoint commit";
	git remote add origin "https://github.com/${PATH_GRANDPARENT}/${PATH_PARENT}.git"
	git push -u --force origin main;
	git branch --set-upstream-to=origin/main main;
	git pull;git push;
	git tag -d ${CURRENT_VERSION};git push origin --delete ${CURRENT_VERSION};git tag ${CURRENT_VERSION};git push --tags;

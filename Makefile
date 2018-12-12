.PHONY: helm-package

helm-package:
	helm package charts/vsts-agent -d charts
	helm repo index --merge charts/index.yaml charts

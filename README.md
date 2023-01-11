# tenant-t1-tst-repo

Here we are following environment per repository strategy in order to avoid merge conflicts and cherry pickking issues.

### Rules behind environment promotion
1. Small pull requests should be encouraged
2. For a environment promotion from DEV to QA,

    a. All folders are promotable to QA repository expect configs/specific
    
    b. Environment specific configurations changes should be put in the config/specifics folder and a separate pull request per repository.
    
    c. It is important to carefully choose the environment specific configurations, so that these don't change frequently. 

3. When introducing a new promotable configuration(feature request), it can be put in the config/promotables folder until it is release to production.

4. Later on, the configuration can be promoted to as a common configuration(config/commons)

### Directtory Structure
```code
├── base  <<-------------------------------- can be directly copied to QA repo
│   ├── kustomization.yaml
│   └── release.yaml
├── configs
│   ├── commons <<-------------------------- can be directly copied to QA repo
│   │   ├── envs
│   │   ├── files
│   │   ├── kustomization.yaml
│   │   └── values
│   ├── kustomization.yaml
│   ├── promotables <<---------------------- can be directly copied to QA repo
│   │   ├── envs
│   │   ├── files
│   │   ├── kustomization.yaml
│   │   └── values
│   └── specifics <<------------------------ can NOT be directly copied to QA repo
│       ├── envs
│       ├── files
│       ├── kustomization.yaml
│       └── values
├── deploy <<------------------------------- can be directly copied to QA repo
│   ├── kustomization.yaml
│   ├── values-patch.yaml
│   └── version-patch.yaml
└── kustomization.yaml <<------------- (kustomize build .) => renders full deployment
```

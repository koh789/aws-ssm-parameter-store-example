# aws-ssm-parameter-store-example

サンプル.  
AWS SSMのDynamic reference検証用exampleです。

# 構築手順

## Dynamic reference

s3 deploy 

```make cfn-param-store-s3-deploy```


Dynamic reference検証用. 参照側のdeploy

```make cfn-param-store-deploy```

Dynamic reference検証用. 参照側のupdate

```make cfn-param-store-update```

## CrossStack reference

s3 deploy

```make cfn-cross-ref-s3-deploy```

Cross stack reference検証用. 参照側のdeploy

```make cfn-cross-ref-deploy```


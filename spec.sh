#!/bin/bash

echo '请输入需要WyhArrowToast.podspec需要push的spec名称'

read spec

pod repo push $spec WyhArrowToast.podspec --allow-warnings --verbose --use-libraries
pod repo update $spec

#!/usr/bin/env nu

source scripts/common.nu
source scripts/kubernetes.nu
source scripts/crossplane.nu
source scripts/argocd.nu
source scripts/atlas.nu

def "main" [] {}

def "main setup" [] {

    main create kubernetes kind --name dot

    main print source

    main apply crossplane --provider google --db-config true

    main apply argocd

    main apply atlas

    main print source

}

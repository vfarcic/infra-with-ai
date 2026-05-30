#!/usr/bin/env nu

source scripts/common.nu
source scripts/kubernetes.nu
source scripts/crossplane.nu
source scripts/argocd.nu
source scripts/atlas.nu
source scripts/dot-ai.nu
source scripts/ingress.nu

def "main" [] {}

def "main setup" [] {

    main create kubernetes kind --name dot

    let ingress = main apply ingress nginx --provider kind

    main apply crossplane --provider google --db-config true

    main apply argocd

    main apply atlas

    main print source

    main apply dot-ai --host $env.ingress.host

}

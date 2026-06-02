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

}

def "main destroy" [] {

    main destroy kubernetes kind --name dot --delete_project true

    print $"(ansi red_bold)Delete(ansi reset) manually both the remote and local copies of the (ansi red_bold)repository(ansi reset)."

}

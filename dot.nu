#!/usr/bin/env nu

source scripts/common.nu
source scripts/kubernetes.nu
source scripts/crossplane.nu
source scripts/argocd.nu
source scripts/atlas.nu
source scripts/dot-ai.nu
source scripts/ingress.nu

def "main" [] {}

def "main get ai" [] {

    let provider_name = [OpenAI Gemini Anthropic] | input list $"
Select the AI provider for DevOps AI Toolkit

(ansi yellow_bold)Select a provider(ansi green_bold)"
    print $"(ansi reset)"

    if $provider_name == "OpenAI" {

        mut key = ""
        if OPENAI_API_KEY in $env {
            $key = $env.OPENAI_API_KEY
        } else {
            $key = input $"(ansi green_bold)Enter OpenAI API Key: (ansi reset)" --suppress-output
            print ""
        }

        {provider: openai, model: gpt-4o, openai_api_key: $key, google_api_key: "", anthropic_api_key: ""}

    } else if $provider_name == "Gemini" {

        mut key = ""
        if GOOGLE_GENERATIVE_AI_API_KEY in $env {
            $key = $env.GOOGLE_GENERATIVE_AI_API_KEY
        } else {
            $key = input $"(ansi green_bold)Enter Google Gemini API Key: (ansi reset)" --suppress-output
            print ""
        }

        {provider: google, model: gemini-3-pro, openai_api_key: "", google_api_key: $key, anthropic_api_key: ""}

    } else {

        mut key = ""
        if ANTHROPIC_API_KEY in $env {
            $key = $env.ANTHROPIC_API_KEY
        } else {
            $key = input $"(ansi green_bold)Enter Anthropic API Key: (ansi reset)" --suppress-output
            print ""
        }

        {provider: anthropic, model: claude-haiku-4-5-20251001, openai_api_key: "", google_api_key: "", anthropic_api_key: $key}

    }

}

def "main setup" [] {

    main create kubernetes kind --name dot

    let ingress = main apply ingress nginx --provider kind

    main apply crossplane --provider google --db-config true

    main apply argocd

    main apply atlas

    let ai = main get ai

    (
        main apply dot-ai
            --host $ingress.host
            --provider $ai.provider
            --model $ai.model
            --openai-api-key $ai.openai_api_key
            --google-api-key $ai.google_api_key
            --anthropic-api-key $ai.anthropic_api_key
    )

    main print source

}

def "main destroy" [] {

    main destroy kubernetes kind --name dot --delete_project true

    print $"(ansi red_bold)Delete(ansi reset) manually both the remote and local copies of the (ansi red_bold)repository(ansi reset)."

}

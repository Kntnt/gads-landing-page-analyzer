# gads-landing-page-analyzer

A Claude skill that analyzes a landing page and produces a structured keyword report for Google Ads campaign setup.

## What it does

Given a landing page (URL, screenshot, or page content as text), the skill answers eight questions:

1. **Target segments and offer** -- who the page addresses and what it sells
2. **Sender** -- the specific brand or entity behind the page
3. **Geographic scope** -- whether targeting is narrower than national
4. **CTA character** -- whether the call-to-action is specific or generic
5. **Key terms** -- words and phrases on the page relevant for ads
6. **Search queries** -- what the target segments would type in Google
7. **Clustering** -- grouping queries into ad-group-ready clusters
8. **SERP enrichment** (optional) -- supplementing clusters with data from Google search results

The output is a Markdown file with clustered search queries, each annotated with target segment, offer, and search intent -- plus negative keywords and (when SERP enrichment is enabled) a keyword gap analysis showing relevant terms competitors rank for that the page doesn't address. Ready to transfer into Google Ads.

## When it triggers

The skill activates when you ask Claude to analyze a landing page for advertising, generate keyword clusters from a web page, or build ad group foundations -- even without explicitly saying "Google Ads". Swedish trigger phrases like "analysera landningssida", "sökord för sidan", "keyword-underlag", and "annonsgrupper" also work.

## Installation

In Claude Desktop (Cowork), install the packaged `.skill` file via the skill installer. Alternatively, copy this repository into your skills directory.

## Repo structure

```
SKILL.md                           Main skill instructions
references/
  output-format.md                 Markdown output format specification
  search-query-generation.md       Query generation and clustering rules
  example-safeteam.md              Example: local access control provider
  example-spiris.md                Example: national SaaS accounting platform
  example-grown.md                 Example: B2B strategy consultancy
evals/
  evals.json                       Test cases for skill evaluation
```

## Examples

Three reference analyses are bundled to calibrate output quality:

- **SafeTeam Linköping** -- a local service provider selling access control systems to housing cooperatives, property managers, and businesses in Östergötland. Demonstrates handling of multiple segments, geographic targeting, and secondary offers (intercom, digital locks, laundry booking).

- **Spiris** -- a national SaaS accounting platform (formerly Visma eEkonomi) targeting sole proprietors, startups, and small employers. Demonstrates specific CTA ("Prova gratis"), competitor mentions, and pricing-driven clusters.

- **Grown** -- a B2B strategy consultancy selling transformation programs to mid-sized companies. Demonstrates broad homepage analysis, title-tag vs. body-text distinctions, and abstract service offerings.

## Suggested workflow

1. Create a project directory for the campaign you're working on – if one doesn't already exist.
2. Add a `CLAUDE.md` file in the project root with background information about the sender, industry, target audiences, value propositions, and anything else that's relevant. The skill reads this file automatically and uses it to improve the analysis.
3. Trigger the skill with a prompt like: *"Analyze this landing page for Google Ads: https://example.com/service"*

## License

MIT

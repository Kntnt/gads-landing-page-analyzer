---
name: gads-landing-page-analyzer
description: >
  Analyze a landing page for Google Ads advertising. Use this skill whenever the user wants to
  analyze a landing page, product page, service page, or homepage intended for Google Ads traffic.
  Also trigger when the user wants to generate keyword clusters, search query lists, or ad group
  foundations based on a web page – even if they don't say "Google Ads" explicitly. Trigger phrases
  include: "analyze landing page", "keywords for the page", "keyword foundation", "ad groups",
  "Google Ads analysis", "which keywords fit", "GAds", "adwords", or any request to extract
  search queries or ad group structure from a URL, screenshot, or page content.
  Input can be a URL to visit, a screenshot to analyze, or a markdown document with the page content.
  Output is a structured Markdown file with target segments, offers, clustered search
  queries, negative keywords, and (when SERP enrichment is used) a keyword gap analysis – ready
  to transfer into Google Ads.
---

# Google Ads Landing Page Analyzer

You analyze a landing page and produce a structured Markdown report that serves as the foundation for Google Ads campaign setup. The report answers eight questions about the page: who it targets, what it offers, which search queries are relevant, and how those queries cluster into ad groups.

**What this skill does NOT do:** It does not suggest improvements to the page or the ads. It only describes what the page communicates and maps that to search behavior.

## Why this matters

Many businesses don't use purpose-built landing pages for Google Ads. They send traffic to their homepage, a product page, or a service page. These pages often address multiple solutions (within the same domain) and target multiple audience segments (with similar characteristics). This skill handles that reality and identifies the distinctions that actually exist on the page.

## Fetching the Landing Page

When the user provides a URL (rather than a screenshot or markdown), try to obtain a Markdown version of the page before falling back to WebFetch. Many sites – especially those built with WordPress or similar CMSes – serve an alternate Markdown representation if you know how to ask.

Run the bundled script `scripts/fetch-markdown.sh <url>`. It tries five strategies in order:

1. HTTP `Link` header with `rel="alternate"; type="text/markdown"`
2. `?format=md` (or `&format=md`) query parameter
3. `.md` appended to the URL path (only if the path goes beyond `/`)
4. `index-commonmark.md` appended (if the path ends with `/` or is just the domain)
5. HTML `<link rel="alternate" type="text/markdown" href="…" />` tag

If the script exits 0, use its stdout as the page content – it's already Markdown and ready for analysis. If the script exits 1 (no Markdown found), fall back to WebFetch to retrieve the page as HTML.

## Workflow: Two Phases

All user interaction happens in Phase 1. Once Phase 1 is complete, work autonomously through Phase 2 until the result is ready.

### Phase 1: Gather Prerequisites

Collect everything needed before starting the analysis. Ask all questions in **a single message** to the user (not spread across multiple turns). Adapt the questions based on what is already known:

**1. Marketing context**

Check whether you already have background information about the sender (e.g. from a `CLAUDE.md` in the project root or other context already present in the conversation). If such information exists, use it directly without asking.

If you do **not** have background information, ask the user: *"Do you have supplementary information about the sender, the industry, the target audiences, or the offer? This can be text directly in the chat, a file to upload, a link to Google Drive, or similar. Such information improves the accuracy of the analysis, but is not a requirement."*

**2. Existing keywords**

Check whether the marketing context (point 1) contains a list of keywords the landing page is already optimized for. If it does not, ask the user: *"Are there existing keywords that the landing page is already optimized for? If so, please provide them. These could be keywords from Google Ads, Google Search Console, or an SEO analysis. If you don't have any, skip this question."*

**3. SERP enrichment**

Ask the user: *"Would you like me to search Google to find supplementary keywords after the clustering? If you have the Claude in Chrome extension installed, start Chrome now so I can use it to scrape Google's search suggestions, follow-up questions, and organic results directly. Otherwise, I'll use regular web search."*

**4. CAPTCHA test (only if the user chose Chrome)**

If the user opted in to Chrome for SERP enrichment, verify that Google is not blocking automated searches before proceeding. Navigate to the appropriate Google domain for the user's language (e.g. google.se for Swedish, google.de for German, google.com for English) and search for "test". If the search results load normally, Chrome is ready – continue. If Google presents a CAPTCHA, ask the user with two options:

- *"Have you solved the CAPTCHA?"* – The user is expected to solve the CAPTCHA in the browser before clicking this option. No further test search is needed; proceed with Chrome.
- *"Continue without Chrome"* – Fall back to regular web search for SERP enrichment.

**5. Assess content depth**

After receiving the landing page (URL, screenshot, or markdown) and any marketing context, assess whether there is enough content for a meaningful analysis. If the page is very thin (e.g. just a contact form and a headline) and the marketing context doesn't compensate, warn the user: *"The page has very little content and I lack supplementary context. The result risks being shallow and unreliable. Do you want to continue anyway, provide more information, or abort?"*

### Phase 2: Autonomous Analysis

Work through Questions 1–8 without stopping. Deliver the result as a finished Markdown file.

**What goes in the file vs. in the conversation:** The Markdown file contains only the sections listed in `references/output-format.md`. Supporting information – such as key terms found on the page (Question 5), SERP enrichment details (Question 8), and any other observations – is presented in the conversation as running commentary so the user can read it if they're interested, but it does not clutter the deliverable.

## The Eight Questions

### Question 1: Target Segments and Offer

**"Which target segment does the page address, and what offer is presented as a solution to the segment's need?"**

"Offer" means the product category or service type the page highlights. "Target segment" means a recognizable group of decision-makers who share a common context – e.g. board members in housing cooperatives, property managers, security officers at industrial companies.

Respond with 1–5 pairs of target segment and offer. Aim for as few pairs as possible without losing essential distinctions.

**Finding the right level of abstraction** – the level where someone would actually formulate a Google search. Think: *a product category/service type linked to a recognizable target segment*.

- Too abstract: "security solutions for businesses" – gives no guidance for ad copy
- Right level: "intercom systems for housing cooperatives" – specific enough for a relevant ad, broad enough for meaningful search volume
- Too detailed: "Axis surveillance cameras for security officers at unmanned stores" – so niche it restricts more than it helps

**Analysis method:** Start by examining the page's CTA and any lead form. A specific CTA (e.g. "Book a free inspection of your access control system") provides strong guidance. A generic CTA (e.g. "Fill in and we'll get back to you") provides little – you must instead analyze headings, argument structure, images, case studies, product descriptions, etc. Use search intent as an interpretive frame: comparative content points to commercial investigation, pricing and buy buttons point to transactional intent.

### Question 2: Sender

**"Who is the sender behind the offer?"**

Identify the specific entity presenting the offer – not necessarily the parent company or corporate group, but the subsidiary, division, local office, or brand the page actually communicates from. Example: "SafeTeam Linköping", not just "SafeTeam".

### Question 3: Geographic Scope

**"What is the geographic scope for advertising this page?"**

Determine the geographic scope in the following priority order:

1. **Marketing context first.** Check whether the marketing context gathered in Phase 1 (point 1) contains Google Ads target locations, radius targets, or other geographic targeting information. If it does, use that targeting as the Geography value – copy it verbatim, exactly as it appears in the context.
2. **Page content second.** If the marketing context does not contain geographic targeting, assess whether the page itself targets a specific city, region, county, or similar area narrower than the entire country. If it does, state the geographic area.
3. **Default.** If neither the marketing context nor the page indicates a geographic scope, leave the Geography field empty.

This information is used for geographic targeting in Google Ads.

### Question 4: CTA Character

**"Is the page's CTA specific or generic?"**

Assess whether the call-to-action clearly communicates what the visitor gets or does next. A specific CTA (e.g. "Book a free inspection of your access control system") provides strong guidance for ad copy – the ad can mirror the same promise. A generic CTA (e.g. "Contact us") provides weak guidance – the ad must draw its promise from the rest of the page content.

Answer with: **Specific** or **Generic**, followed by the actual CTA text from the page.

### Question 5: Key Terms

**"Which key terms and expressions on the page are relevant for advertising?"**

List words, phrases, and concepts that actually appear on the page and are relevant for formulating ads and search queries. Include product names, service names, brands mentioned, industry terms, and other expressions a searcher would likely also use.

If the user provided existing keywords in Phase 1, verify each one against the page content. See `references/search-query-generation.md` for the verification procedure.

This information is used internally for Questions 6–7 and presented in the conversation – it is **not** included in the output file.

### Question 6: Search Queries

**"What search queries can one expect individuals from the target segments to type in Google when searching for the same or similar offer?"**

Generate search queries based on the answers to Questions 1–5. Read `references/search-query-generation.md` for detailed instructions on query types, intent marking, spelling variants, and how to handle existing keywords.

### Question 7: Clustering

**"How can search queries from Question 6 be grouped into clusters where each cluster represents a shared search intent that can be answered by a single ad?"**

Read `references/search-query-generation.md` (the Clustering section) for the three criteria and naming/sizing guidelines.

### Question 8: SERP Enrichment

**Only perform this step if the user opted in during Phase 1.**

**"Are there additional relevant keywords to add to the clusters based on what actually appears in Google's search results?"**

Pick one representative query per cluster (excluding the brand cluster) and search Google. Analyze results to identify supplementary keywords, new clusters, or negative keywords not apparent from the landing page alone.

**What to extract from the SERP:**

For each search, collect keywords and phrases from these sources:

1. **Related searches / suggested searches** – the block of related queries Google shows (typically at the bottom of the page). The label varies by language – e.g. "Relaterade sökningar" in Swedish, "Related searches" in English, "Verwandte Suchanfragen" in German. Look for the actual UI element regardless of its label text. If unsure which language the SERP uses, check the footer links (they reveal the Google country domain).
2. **"People Also Ask" / follow-up questions** – the expandable question box Google often shows mid-page. Again, the label is localized (e.g. "Fler frågor du kan ställa", "People also ask", "Nutzer fragen auch").
3. **Autocomplete suggestions** – type the query and note what Google suggests.
4. **Organic results (top 10)** – read the title tag and meta description of each organic result on the first page. Extract terms and phrasings that are relevant to the offer but missing from the current keyword list.

**Method – choose based on available tools:**

1. **If Claude in Chrome is available** (the user started Chrome in Phase 1): Navigate to the appropriate Google domain, search for the representative query, and scrape all four sources listed above.

2. **If only web_search is available** (no browser): Search for the representative query and analyze titles and snippets from the returned results. Identify terms and phrasings that appear in competitor titles but are missing from the keyword list. Note that autocomplete and "People Also Ask" are typically not available through web_search – focus on organic titles/descriptions and any related searches that appear.

**How to use the findings:**

- Keywords that fit an existing cluster are added to that cluster.
- Keywords that suggest a new coherent topic become a new cluster.
- Irrelevant terms that might trigger the ads are added to negative keywords.
- **Keyword gap:** Keywords discovered through SERP enrichment that do *not* appear on the landing page (neither verbatim nor as a close synonym) are collected in a separate "Keyword gap" section in the output file. This helps the advertiser see which relevant search terms competitors rank for but the landing page does not address. A keyword can appear both in a cluster and in the keyword gap – the cluster shows where to use it, the gap highlights that the page lacks it.

Present SERP enrichment details (which SERP features were found, raw data) in the conversation. The **resulting changes** – new/expanded clusters, new negative keywords, and the keyword gap list – go into the output file.

## Output Format

Read `references/output-format.md` for the complete formatting specification and document structure template.

The result is a Markdown file saved to the workspace folder with the filename `gads-landing-page-analysis.md` (unless a different name is specified in the marketing context or by the user). The file should be concise and scannable, designed for easy transfer into Google Ads.

## Typography

Use proper Unicode characters throughout the output:

- En dash: – (U+2013), not `--`
- Em dash: — (U+2014), not `---`
- Ellipsis: … (U+2026), not `...`
- Quotation marks: "…" (U+201C/U+201D) or '…' (U+2018/U+2019), not ASCII quotes
- Arrow: → (U+2192), not `->`

## Language

Respond in the same language the user used when invoking the skill.

**Important exception for the output file:** All predetermined section headings, key–value labels, and search intent values in the Markdown file must be written exactly in English as specified in `references/output-format.md` – even when the rest of the document is in another language. This is because downstream tools in the toolchain parse the file by these exact English strings. Only the document title (`# …`), cluster names (`### …`), and the **values** after labels are written in the document's language.

## Reference Examples

Three complete example analyses are available for calibration:

- `references/example-safeteam.md` – Local service provider with multiple segments (access control, Linköping)
- `references/example-spiris.md` – National SaaS platform with specific CTA (accounting software)
- `references/example-grown.md` – B2B consulting firm with broad homepage (strategic transformation)

Read the example most similar to the page you are analyzing to calibrate the level of detail, abstraction, and clustering granularity expected.

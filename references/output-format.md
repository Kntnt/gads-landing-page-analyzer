# Output Format Specification

The analysis is delivered as a single Markdown file. The file should be concise and scannable, designed to transfer easily into Google Ads.

## Fixed headings and labels – always in English

Downstream tools in the toolchain (RSA creator, Google Ads Editor CSV generator) locate information in this file by matching specific heading names and field labels. To ensure reliable parsing, all **predetermined** headings and labels listed in the Document Structure below must be written **exactly as shown, in English**, regardless of which language the rest of the document is written in.

This applies to:

- Section headings: `## Summary`, `## Target segments and offers`, `## Keyword clusters`, `## Negative keywords`, `## Keyword gap`
- Key–value labels in the Summary block: `**Page:**`, `**Sender:**`, `**Geography:**`, `**CTA:**`
- Key–value labels inside each cluster: `**Target segment:**`, `**Offer:**`, `**Search intent:**`
- Search intent values: *navigational*, *informational*, *commercial investigation*, *transactional*

Headings that are created dynamically – the document title (`# …`) and each cluster name (`### …`) – follow the document's language (i.e. the language the user used when invoking the skill). The **values** after the fixed labels (e.g. the sender name, the geographic scope, the segment description) also follow the document's language.

## Formatting Rules

- **Heading 1 (#)** is used only for the document title. Base the title on the page's main topic and sender (e.g. "Passage System in Linköping – SafeTeam Linköping").
- **Headings 2–6 (##–######)** are used for all other headings with correct semantic hierarchy.
- Headings should be result-oriented – they must **not** mirror the underlying analysis questions (e.g. not "Question 7 – Clustering" but "Keyword clusters").
- Do not use tables. Use bullet lists, bold key–value pairs, or running text.
- Search queries are presented directly in clustered form – never first as a flat list and then again in clusters.
- Each keyword cluster must state: **Target segment**, **Offer**, and **Search intent** (using exactly these English labels) – in addition to the cluster name and keyword list.
- Search intent is written out in full: *navigational*, *informational*, *commercial investigation*, *transactional* – never as abbreviations, always in English.
- Search categories are written out in full (e.g. "Brand searches", "Offer searches") – never as "A", "B", "C" etc.
- Use proper Unicode characters: – (en dash), → (arrow), "…" (smart quotes), … (ellipsis). Never use ASCII substitutes like `--`, `->`, or `...`.

## Document Structure

The output file contains these sections (the "Keyword gap" section is conditional – see below):

```markdown
# [Title based on topic and sender]

## Summary

**Page:** [URL if available, otherwise identify the page as precisely as possible – e.g. domain + breadcrumb path, or company name + page title]
**Sender:** [sender]
**Geography:** [geographic scope or "no limitation (national)"]
**CTA:** [Specific/Generic] – "[actual CTA text]"

## Target segments and offers

- [Segment] → [offer]
- ...

## Keyword clusters

### [Cluster name]

**Target segment:** [segment(s)]
**Offer:** [offer]
**Search intent:** [intent in full]

- keyword 1
- keyword 2
- ...

[repeat for each cluster]

## Negative keywords

- [term]
- ...

## Keyword gap

- [term found in SERP but missing from the landing page]
- ...
```

The "Keyword gap" section is only included when SERP enrichment (Question 8) was performed and yielded keywords that do not appear on the landing page. If no SERP enrichment was done, or if all discovered keywords already exist on the page, omit this section entirely.

Other analysis outputs – key terms from the page, SERP enrichment details, verification of existing keywords – belong in the conversation, not in this file. Keeping the file lean makes it easier to transfer directly into Google Ads.

# Output Format Specification

The analysis is delivered as a single Markdown file. The file should be concise and scannable, designed to transfer easily into Google Ads.

## Formatting Rules

- **Heading 1 (#)** is used only for the document title. Base the title on the page's main topic and sender (e.g. "Passage System in Linköping – SafeTeam Linköping").
- **Headings 2–6 (##–######)** are used for all other headings with correct semantic hierarchy.
- Headings should be result-oriented – they must **not** mirror the underlying analysis questions (e.g. not "Question 7 – Clustering" but "Keyword clusters").
- Do not use tables. Use bullet lists, bold key–value pairs, or running text.
- Search queries are presented directly in clustered form – never first as a flat list and then again in clusters.
- Each keyword cluster must state: **target segment**, **offer**, and **search intent** – in addition to the cluster name and keyword list.
- Search intent is written out in full: *navigational*, *informational*, *commercial investigation*, *transactional* – never as abbreviations.
- Search categories are written out in full (e.g. "Brand searches", "Offer searches") – never as "A", "B", "C" etc.
- Use proper Unicode characters: – (en dash), → (arrow), "…" (smart quotes), … (ellipsis). Never use ASCII substitutes like `--`, `->`, or `...`.

## Document Structure

The output file contains **only** these sections – nothing more:

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
```

Other analysis outputs – key terms from the page, SERP enrichment details, verification of existing keywords – belong in the conversation, not in this file. Keeping the file lean makes it easier to transfer directly into Google Ads.

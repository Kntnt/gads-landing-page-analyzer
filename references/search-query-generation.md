# Search Query Generation – Detailed Instructions

This document covers how to generate search queries (Question 6) and how to cluster them (Question 7).

## Query Types

Work through each type below. Not all types will apply to every page, but consider each one:

### Brand searches

The sender's name, alone and combined with cities mentioned on the page or within the geographic area. Brand searches always form their own cluster.

### Offer searches

Terms and synonyms for what is offered, alone or combined with:
- Qualifiers mentioned on the page (features, materials, certifications)
- Words that signal the target segment (e.g. "HOA", "company", "office")

Guidelines:
- Keep queries short – typically 1–3 words without filler words like "with", "for", "in".
- Include synonyms that do NOT appear on the page but refer to the same thing.
- Do NOT include city/region names – geographic targeting is handled in Google Ads.

### Problem searches

How does each target segment describe their problem before they know the solution? Think about the pain points, frustrations, and situations that lead someone to search. Examples: "unauthorized persons in stairwell", "difficult to manage keys for property".

### Comparative and evaluative searches

Queries with "best", "price", "comparison", "vs", "test", "rating", "review" and similar. Examples: "best access control system HOA", "Aptus vs Axema".

### Negative keywords

Terms to exclude – those that resemble the offer but mean something else, or signal a target segment the page does not address. Only include negatives that are likely to cause real problems (wasted ad spend). List each negative keyword as a bare term without explanations or parenthetical reasons.

## Search Intent

Mark every search query (except brand searches) with its probable search intent, written out in full and always in English (these values are parsed by downstream tools):

- **navigational** – the searcher wants a specific website or page
- **informational** – the searcher wants to learn or understand something
- **commercial investigation** – the searcher is evaluating options before a decision
- **transactional** – the searcher is ready to take action (buy, book, sign up)

## Spelling Variants

Include common spelling variations that are likely to generate search volume:
- Split compounds: "access control system" as a variant of "accesscontrolsystem"
- Alternative compounds: "accounting program" vs "accountingprogram"
- These are important because Google may not always match them automatically.

## Verification of Existing Keywords

If the user provided existing keywords during Phase 1:
1. Check that each keyword appears on the page – either verbatim or as a close synonym (e.g. "camera surveillance Stockholm" and "camera surveillance in Stockholm" count as a match).
2. Confirmed keywords must be used exactly as the user provided them – do not rephrase or abstract.
3. List separately which existing keywords were confirmed and which were not found on the page.

## Clustering (Question 7)

Group search queries that meet **all three** criteria:

1. **Same intent:** The person wants to achieve the same thing.
2. **Same topic area:** The terms concern the same subject. "Access control system HOA" and "camera surveillance HOA" concern different topics even if the target segment is the same.
3. **Same ad works:** Can you write a Responsive Search Ad with headlines and descriptions that feel relevant for every keyword in the group? If not, split the cluster.

### Cluster naming and sizing
- Give each cluster a short descriptive name (e.g. "Access Control System HOA – price/evaluation").
- If a cluster has more than 15–20 keywords, consider splitting it.
- If two clusters would produce identical ads, merge them.
- Brand searches always form their own cluster.
- Negative keywords are not clustered – they are applied at campaign or ad group level.

### Cluster metadata
Each cluster must include these three fields, using the exact English labels shown here (they are parsed by downstream tools):
- **Target segment:** which segment(s) the cluster addresses
- **Offer:** what is being offered
- **Search intent:** the dominant search intent for the cluster (always one of: *navigational*, *informational*, *commercial investigation*, *transactional* – in English)

# Client Documents

This folder contains documents, materials, and context provided by the Alpha Peer client.

## What Goes Here

### Client-Provided Materials
- Requirements documents
- Business briefs
- Feature requests
- Meeting notes from client discussions
- Design mockups or wireframes
- Brand guidelines
- User research from client
- Market analysis
- Competitive analysis

## Organization
- Files are processed via the `/add-client-doc` command
- Drop files in `/MyResearch/file_holding/` first
- Claude reads, moves to this folder, and indexes them
- Use original filenames when possible
- Add date prefix if helpful: `YYYY-MM-DD-[original-name]`
- Create subfolders if you receive many documents in categories

## Important Notes

**Reference, Don't Modify:**
- These are source documents - don't edit originals
- If you need to annotate or modify, create a copy in the appropriate project folder

**Track in Research:**
- When client docs influence decisions, reference them in:
  - `/research/` notes
  - `/decisions/` files
  - User stories
  - Needs.md

**Version Control:**
- If client provides updated versions, keep old versions with version numbers
- Example: `requirements-v1.pdf`, `requirements-v2.pdf`

## Integration with Project

Client documents should inform:
- User stories (what the client needs)
- Technology decisions (constraints or preferences)
- Architecture decisions (business requirements)
- Non-functional requirements (performance, security, scale)

Always trace back to client docs when making decisions that affect scope or approach.

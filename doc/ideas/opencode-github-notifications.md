# GitHub Notifications for OpenCode

## Concept

Build a lightweight `GitHub Notifications` integration that delivers GitHub webhook events directly into active OpenCode sessions.

The goal is to make OpenCode event-driven, allowing the agent to react to GitHub activity without polling or requiring manual prompts.

## Architecture

1. GitHub sends webhooks for events such as PR creation, review submissions, issue assignments, and comments.
2. A dedicated notification service receives and processes these events.
3. The service identifies the relevant OpenCode session.
4. It uses OpenCode's **Synthetic Message API** to inject a notification into that session.
5. OpenCode receives the event as model-readable input and can decide whether action is needed.

## Technical Integration

Use OpenCode's experimental endpoint:

`POST /api/experimental/session/{sessionID}/synthetic`

Synthetic messages are particularly suitable because they let external services introduce notifications into an existing conversation as model-readable input, without pretending the user manually typed them.

## Example

A GitHub webhook reports a new review on PR #142.

The notification service injects:

> [GitHub Notification] A new review was submitted on PR #142. Repository: myorg/myproject. Author: alice. Check whether this requires any action.

The agent can then inspect the PR using its existing GitHub authentication and decide what to do.

## Design Principles

- No periodic polling.
- Reuse OpenCode's existing sessions and GitHub authentication.
- Deliver notifications asynchronously.
- Keep notifications contextual and concise.
- Let the agent decide whether an event requires action.
- Support multiple event types and configurable notification filters.

**Expected outcome:** OpenCode becomes an event-aware coding agent that can proactively respond to GitHub activity while maintaining its existing conversation context.

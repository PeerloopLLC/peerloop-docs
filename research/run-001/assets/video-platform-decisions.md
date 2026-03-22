# Video Platform Decisions - RUN-001

> **⚠️ MIGRATED:** This content has been integrated into `docs/reference/plugnmeet.md` (2026-01-19).
> This file is kept for historical reference. For current information, see the tech doc.

**Created:** 2025-12-24
**Updated:** 2025-12-26
**Migrated:** 2026-01-19 → `docs/reference/plugnmeet.md`
**Related Global Research:**
- `docs/reference/bigbluebutton.md`
- `docs/reference/plugnmeet.md`

---

## Decision: PlugNmeet ✅ RESOLVED

RUN-001 will use **PlugNmeet** as the video platform, implementing the VideoProvider interface.

### Final Decision (2025-12-26)

| Factor | Value |
|--------|-------|
| Platform | **PlugNmeet** |
| Decided by | Brian (via user) |
| Rationale | Lower cost, modern UX, lighter infrastructure requirements |

### Original Considerations

| Factor | Consideration |
|--------|---------------|
| Timeline | 4 months - can't afford wrong choice |
| Options | BBB (established) vs PlugNmeet (modern, unproven) |
| Brian's Status | Completed PlugNmeet evaluation |
| Risk Mitigation | Interface still allows swap if needed |

### Interface Contract (from API.md)

```typescript
interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  deleteRoom(roomId: string): Promise<void>;
  getJoinUrl(roomId: string, participant: Participant): Promise<string>;
  startRecording(roomId: string): Promise<RecordingId>;
  stopRecording(recordingId: string): Promise<RecordingUrl>;
  getRecording(recordingId: string): Promise<RecordingUrl>;
  getRoomStatus(roomId: string): Promise<RoomStatus>;
}
```

---

## Compliant Platforms

### BigBlueButton

**From bigbluebutton.md (docs/reference/):**

| Aspect | Value | Run Impact |
|--------|-------|------------|
| Hosting | Self-hosted only | Need VM budget (~$80-150/mo) |
| Server Req | 16GB RAM, 8 cores | Significant infrastructure |
| API | Full meeting/recording control | ✅ Covers interface |
| Webhooks | meeting.end, recording.ready | ✅ Covers interface |
| UX | Dated interface | May affect student adoption |

**Open Questions (from tech-001):**
- Hosting model? → **Deferred to implementation**
- Recording retention? → **Deferred to implementation**

### PlugNmeet

**From plugnmeet.md (docs/reference/):**

| Aspect | Value | Run Impact |
|--------|-------|------------|
| Hosting | Self-hosted or Cloud Flex | More options |
| Server Req | $5-10/mo VPS | Lower cost |
| Architecture | Microservices (Go + LiveKit) | Better scaling |
| UX | Modern, Zoom-like | Better adoption |
| Maturity | Newer, less proven | Risk factor |

**Open Questions (from tech-006):**
- Production stability? → **Needs research**
- API compatibility with interface? → **Needs verification**

---

## Run-001 Approach

1. **Build to interface** - All code targets `VideoProvider` interface
2. **Use PlugNmeet** - Brian's chosen platform after evaluation
3. **Keep interface abstraction** - Allows future swap if needed

### Implementation Order

```
Week 1-2: Build VideoProvider interface + PlugNmeet adapter
Week 3-4: Test with real sessions
Week 5+:  Production refinement
```

---

## Cost Comparison (for Genesis Cohort)

| Platform | Model | Est. Monthly Cost | Notes |
|----------|-------|-------------------|-------|
| BBB (self-hosted) | VM | $80-150 | Need ops capacity |
| BBB (Blindside) | Per-session | Variable | Depends on volume |
| **PlugNmeet (self-hosted)** | VPS | **$5-10** | ✅ Selected |
| PlugNmeet (Cloud Flex) | Capacity | TBD | Alternative if self-host is difficult |

**Decision:** PlugNmeet self-hosted, budget ~$10/mo for video infrastructure.

---

## Questions Resolved ✅

| # | Question | Resolution | Date |
|---|----------|------------|------|
| 1 | PlugNmeet production stability | Brian approved after evaluation | 2025-12-26 |
| 2 | PlugNmeet API vs our interface | Will implement PlugNmeet adapter | 2025-12-26 |
| 3 | Self-host vs managed preference | Self-hosted (cost priority) | 2025-12-26 |
| 4 | Recording storage location | Both: PlugNmeet + replicate to R2 | 2025-12-26 |

---

## References

- `docs/reference/bigbluebutton.md` - Full BBB research
- `docs/reference/plugnmeet.md` - Full PlugNmeet research
- `API.md` - VideoProvider interface definition
- `CD-028` - Brian's PlugNmeet discovery

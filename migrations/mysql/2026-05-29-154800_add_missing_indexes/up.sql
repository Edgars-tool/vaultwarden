-- Foreign key columns and frequently filtered columns that lack indexes.
-- These columns appear in WHERE, JOIN, or ORDER BY clauses in the Rust query layer.

-- ciphers: user_uuid is used to find/count ciphers owned by a user
CREATE INDEX idx_ciphers_user_uuid ON ciphers (user_uuid);
-- ciphers: organization_uuid is used to find/count ciphers belonging to an org
CREATE INDEX idx_ciphers_organization_uuid ON ciphers (organization_uuid);

-- attachments: cipher_uuid is used to find attachments for a cipher
CREATE INDEX idx_attachments_cipher_uuid ON attachments (cipher_uuid);

-- folders: user_uuid is used to list folders for a user
CREATE INDEX idx_folders_user_uuid ON folders (user_uuid);

-- devices: user_uuid is used to list/delete devices by user;
-- the composite PK (uuid, user_uuid) does not support user_uuid-only lookups
CREATE INDEX idx_devices_user_uuid ON devices (user_uuid);
-- devices: refresh_token is used to look up a device during token refresh
CREATE INDEX idx_devices_refresh_token ON devices (refresh_token(255));

-- sends: user_uuid is used to list sends for a user
CREATE INDEX idx_sends_user_uuid ON sends (user_uuid);
-- sends: organization_uuid is used to list sends for an org
CREATE INDEX idx_sends_organization_uuid ON sends (organization_uuid);

-- collections: org_uuid is used to list/count collections in an org
CREATE INDEX idx_collections_org_uuid ON collections (org_uuid);

-- users_organizations: org_uuid is the second column in the UNIQUE(user_uuid, org_uuid)
-- constraint, so org_uuid-only lookups require a separate index
CREATE INDEX idx_users_organizations_org_uuid ON users_organizations (org_uuid);

-- users_collections: collection_uuid is the second column in the composite PK
CREATE INDEX idx_users_collections_collection_uuid ON users_collections (collection_uuid);

-- ciphers_collections: collection_uuid is the second column in the composite PK
CREATE INDEX idx_ciphers_collections_collection_uuid ON ciphers_collections (collection_uuid);

-- folders_ciphers: folder_uuid is the second column in the composite PK
CREATE INDEX idx_folders_ciphers_folder_uuid ON folders_ciphers (folder_uuid);

-- groups: organizations_uuid is used to list groups by org
CREATE INDEX idx_groups_organizations_uuid ON groups (organizations_uuid);

-- groups_users: users_organizations_uuid is the second column in the composite PK
CREATE INDEX idx_groups_users_users_organizations_uuid ON groups_users (users_organizations_uuid);

-- collections_groups: groups_uuid is the second column in the composite PK
CREATE INDEX idx_collections_groups_groups_uuid ON collections_groups (groups_uuid);

-- emergency_access: grantor_uuid is used to list emergency access by grantor
CREATE INDEX idx_emergency_access_grantor_uuid ON emergency_access (grantor_uuid);
-- emergency_access: grantee_uuid is used to list emergency access by grantee
CREATE INDEX idx_emergency_access_grantee_uuid ON emergency_access (grantee_uuid);

-- auth_requests: user_uuid is used to find auth requests for a user
CREATE INDEX idx_auth_requests_user_uuid ON auth_requests (user_uuid);

-- event: org_uuid + event_date used together for paginated org event queries
CREATE INDEX idx_event_org_uuid_event_date ON event (org_uuid, event_date);
-- event: cipher_uuid + event_date used together for cipher event queries
CREATE INDEX idx_event_cipher_uuid_event_date ON event (cipher_uuid, event_date);
-- event: event_date is used for cleanup of old events
CREATE INDEX idx_event_event_date ON event (event_date);

-- sso_auth (new table): created_at is used for expiration checks in find/delete queries
CREATE INDEX idx_sso_auth_created_at ON sso_auth (created_at);

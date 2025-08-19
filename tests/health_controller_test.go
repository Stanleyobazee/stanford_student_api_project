package tests

import (
	"testing"
)

func TestHealthCheck_Success(t *testing.T) {
	// Skip this test since it requires database connection
	// TODO: Refactor health controller to use interface for proper testing
	t.Skip("Health controller test requires database connection - skipping in CI")
}

func TestHealthCheck_DatabaseError(t *testing.T) {
	// Skip this test since it requires database connection
	// TODO: Refactor health controller to use interface for proper testing
	t.Skip("Health controller test requires database connection - skipping in CI")
}
package providers

// Provider is a struct that serves as a base type for
// future providers.
type Provider struct {
	providerName string
	name         string
}

// ProviderI specifies the minimum methods a provider needs
// to implement.
type ProviderI interface {
	Load() Provider
	Add() (Provider, error)
	Delete() error
}

// Name returns the name of the provider.
func (p *Provider) Name() string {
	return p.name
}

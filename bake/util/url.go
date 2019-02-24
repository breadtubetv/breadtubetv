package util

import (
	"log"
	"net/url"
)

// URL is a newtype wrapper for url.URL which adds handling for yaml
type URL url.URL

// ParseURL is a wrapper function for url.Parse which returns the URL newtype
func ParseURL(input string) (*URL, error) {
	u, err := url.Parse(input)
	newURL := URL(*u)
	return &newURL, err
}

// MustParseURL is designed for parsing valid URLs, known to be valid at compile time
func MustParseURL(input string) *URL {
	u, err := ParseURL(input)
	if err != nil {
		log.Fatalf("MustParseURL(%q) got err %v", input, err)
	}
	return u
}

func (u URL) String() string {
	ou := url.URL(u)
	return ou.String()
}

// MarshalYAML converts a URL to a literal string (instead of the GO default of
// breaking it up into its components)
func (u URL) MarshalYAML() (interface{}, error) {
	return u.String(), nil
}

// UnmarshalYAML converts a string to a URL
func (u *URL) UnmarshalYAML(unmarshal func(interface{}) error) error {
	strURL := ""
	if err := unmarshal(&strURL); err != nil {
		return err
	}

	newURL, err := url.Parse(strURL)
	if err != nil {
		return err
	}

	*u = URL(*newURL)
	return nil
}

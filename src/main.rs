const VERSION: &str = match option_env!("RELEASE_VERSION") {
    Some(version) => version,
    None => "0.0.0-dev",
};

fn main() {
    println!("continuous-release-nix {VERSION}");
}

#[cfg(test)]
mod tests {
    #[test]
    fn version_is_not_empty() {
        assert!(!super::VERSION.is_empty());
    }
}

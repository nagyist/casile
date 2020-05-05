use std::error;
use subprocess::Exec;

/// Pass command string through to a shell or launch interactive shell
pub fn run(config: &crate::Config, command: Vec<String>) -> Result<(), Box<dyn error::Error>> {
    crate::header(config, "shell-header");
    let mut process = Exec::shell(command.join(" "));
    if config.debug {
        process = process.env("DEBUG", "true");
    };
    process.join()?;
    Ok(())
}

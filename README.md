# Colu Analytics
## Configuration
### Adding or removing widgets
The list of active widgets are listed in run_all.rb
### Environment variables
#### Locally
Listed in config.yml, not checked into source control.
#### Jenkins setup
Build Environment > Inject environment variables to the build process > Properties Content
Here list each one of the variables listed in config.yml but instead of the yml syntax `var: value` use here `var=value` (without spaces, I think)

# Colu Analytics
## Configuration
### Adding or removing widgets
Active widgets are listed in run_all.rb
### Environment variables
#### Locally
Listed in config.yml, not checked into source control.
#### Jenkins setup
Build Environment > Inject environment variables to the build process > Properties Content

List each of the variables in config.yml but instead of the yml syntax `var: value` use `var=value` (without spaces, I think).
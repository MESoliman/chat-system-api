# Use the official Ruby image as the base image
FROM ruby:3.1.6

# Set environment variables
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs default-libmysqlclient-dev netcat-traditional

# Set up the working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile assets (if applicable)
# RUN RAILS_ENV=production bundle exec rake assets:precompile

# Copy the database initialization script
# COPY ./entrypoints/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
# RUN chmod +x /usr/bin/docker-entrypoint.sh

# Expose port
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Run the Rails server
CMD ["./bin/app", "server"]


# Create docker file
@app_name =@app_path.basename.to_s

create_file 'Dockerfile' do
<<-RUBY
FROM ruby:2.4.1
RUN mkdir -p /home/#{@app_name}
ADD . /home/#{@app_name}
WORKDIR /home/#{@app_name}
RUN cd /home/#{@app_name}
RUN gem install bundler
RUN mkdir -p .bundle && bundle install --no-deployment --path=/home/#{@app_name}/.bundle
ENV RAILS_ENV=production
CMD ["puma", "-C", "config/puma.rb"]
RUBY
end

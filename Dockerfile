FROM node:latest

RUN npm install --global release-it \
                         @release-it/bumper \
                         @release-it/keep-a-changelog 

WORKDIR /workspace
RUN git clone https://github.com/vladdoster/dotfiles.git /workspace

RUN ls -al \
 && release-it --config .github/release-it.json \
                       --ci \
                       minor

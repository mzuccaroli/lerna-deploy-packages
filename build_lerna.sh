#!/bin/bash

set -e
npm install lerna    
npx lerna bootstrap
npx lerna run deploy --since HEAD~1

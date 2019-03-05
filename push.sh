#!/bin/bash

git add -A .
git commit -m "fix: updated"


git push gitlab firstattempt
git push github firstattempt
git push origin firstattempt

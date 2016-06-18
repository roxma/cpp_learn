#!/bin/bash

export FOO_ENV="env"
export FOO_CMD="cmd from env"
make FOO_CMD="cmd"

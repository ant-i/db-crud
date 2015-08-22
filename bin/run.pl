#!/usr/bin/env perl

use Mojo::Base;

use environment;

#
# Run mojo application
# 
require Mojolicious::Commands;
Mojolicious::Commands->start_app('Forge');
# Open Chord Charts -- Database of free chord charts
# By: Christophe Benz <christophe.benz@gmail.com>
#
# Copyright (C) 2012 Christophe Benz
# https://gitorious.org/open-chord-charts/
#
# This file is part of Open Chord Charts.
#
# Open Chord Charts is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Open Chord Charts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


{SelectedLocal} = require "models/selected_local"
transpose = require "lib/transpose"


class Chart extends Spine.Model
  @configure "Chart", "composers", "genre", "is_deleted", "key", "local", "parts", "slug", "structure", "title"
  @extend SelectedLocal
  @extend Spine.Model.Ajax
#  @extend Spine.Model.Ajax.Methods
  @include Spine.Log
  logPrefix: "[MODEL] (Chart)"
  @url: "/charts.json"

  @findByKeywords: (keywords) =>
    @select (chart) ->
      chartKeywords = chart.keywords()
      keywords.every (item) -> item in chartKeywords

  @fromJSON: (objects) =>
    objects = super
    dedupedObjects = []
    for object in objects
      originalObject = @findByAttribute "slug", object.slug
      dedupedObjects.push(originalObject or object)
    dedupedObjects

  keywords: =>
    @slug.split("-")

  @slugSort: (a, b) ->
    if a.slug > b.slug then 1 else -1

  transpose: (toKey) =>
    if toKey != @key
      for partName, chords of @parts
        @parts[partName] = (transpose.transposeChord(chord, @key, toKey) for chord in chords)
      @key = toKey
    @


module?.exports.Chart = Chart

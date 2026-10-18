-- Gokujo Git Layer Module
-- Integrates git path management with the Gokujo Layer Architecture
-- Hosted at: https://github.com/meta-introspector/llama.cpp

open Lean
import UnionUrl
import Slicer
import GokujoLayers

namespace GokujoGitLayer

/-- Canonical git SCM URL for the Llama.cpp repository -/
def canonicalGitUrl : String :=
  "https://github.com/meta-introspector/llama.cpp.git"

/-- Read relative paths from the Aristotle git repository -/
-- Path: /mnt/data1/all_aristo_git.txt
def readAristoPaths : List String :=

let gitFilePath : String := "/mnt/data1/all_aristo_git.txt"
 
if hasFile gitFilePath then
  let content : String := getFileContents gitFilePath
  content.split("\n").filter (λ line, line ≠ "")
else
  List.nil

/-- Canonical git SCM path for hosting the plugin -/
def gitLayerHostPath : String :=
  "lean-worker/gokujo-git-layer"

/-- Plugin metadata for SCM hosting -/
structure PluginMeta where
  name : String := "Gokujo Git Layer"
  version : String := "1.0.0"
  description : String :=
    "Gokujo Git Layer integration for Lean Worker Twin with path management from Aristotle git repository"
  author : String := "Llama Worker Twin Project"
  repoUrl : String := canonicalGitUrl
  hostPath : String := gitLayerHostPath

/-- Host the plugin in the canonical SCM location -/
def hostPlugin (meta : PluginMeta) : String :=
  "Hosting " ++ meta.name ++ " v" ++ meta.version ++
  " at " ++ meta.repoUrl ++ "::" ++ meta.hostPath

/-- Parse a git path entry from the Aristotle repository -/
def parseGitPath (line : String) : Option String :=
  if line = "" then
    none
  else
    some line

/-- Extract lean file paths from the git entries -/
def extractLeanPaths (paths : List String) : List String :=
  paths.filter (λ path, path.endsWith ".lean")

/-- Get all lean paths from the Aristotle git repository -/
def getLeanPaths : List String :=
  readAristoPaths |> extractLeanPaths

/-- Display git layer status -/
def displayGitLayerStatus : IO Unit :=
  do.print "=== Gokujo Git Layer Status ==="
  do.print ("Canonical URL: " ++ canonicalGitUrl)
  do.print ("Plugin host path: " ++ gitLayerHostPath)
  do.print ("Lean paths found: " ++ LeanPaths.length)
  do.print ("All paths count: " ++ readAristoPaths.length)
  do.print ""
  do.print "Lean paths:"
  LeanPaths.iter (λ path, do.print ("  - " ++ path))

-- Export the lean paths for use by other modules
def leanPaths : List String := getLeanPaths

-- Debug output
#eval displayGitLayerStatus
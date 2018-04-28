#####################################################################
#
# editor.py
#
# A general purpose text editor, built on top of the win32ui edit
# type, which is built on an MFC CEditView
#
#
# We now support reloading of externally modified documented
# (eg, presumably by some other process, such as source control or
# another editor.
# We also suport auto-loading of externally modified files.
# - if the current document has not been modified in this
# editor, but has been modified on disk, then the file
# can be automatically reloaded.
#
# Note that it will _always_ prompt you if the file in the editor has been modified.


import win32ui
import win32api
import win32con
import regex
import re
import string
import sys, os
import traceback
from pywin.mfc import docview, dialog, afxres

from pywin.framework.editor import GetEditorOption, SetEditorOption, GetEditorFontOption, SetEditorFontOption, defaultCharacterFormat

patImport=regex.symcomp('import \(<name>.*\)')
patIndent=regex.compile('^\\([ \t]*[~ \t]\\)')

ID_LOCATE_FILE = 0xe200
ID_GOTO_LINE = 0xe2001
MSG_CHECK_EXTERNAL_FILE = win32con.WM_USER+1999 ## WARNING: Duplicated in document.py and coloreditor.py

# Key Codes that modify the bufffer when Ctrl or Alt are NOT pressed.
MODIFYING_VK_KEYS = [win32con.VK_BACK, win32con.VK_TAB, win32con.VK_RETURN, win32con.VK_SPACE, win32con.VK_DELETE]
for k in range(48, 91):
	MODIFYING_VK_KEYS.append(k)

# Key Codes that modify the bufffer when Ctrl is pressed.
MODIFYING_VK_KEYS_CTRL = [win32con.VK_BACK, win32con.VK_RETURN, win32con.VK_SPACE, win32con.VK_DELETE]

# Key Codes that modify the bufffer when Alt is pressed.
MODIFYING_VK_KEYS_ALT = [win32con.VK_BACK, win32con.VK_RETURN, win32con.VK_SPACE, win32con.VK_DELETE]


# The editor itself starts here.
# Using the MFC Document/View model, we have an EditorDocument, which is responsible for
# managing the contents of the file, and a view which is responsible for rendering it.
#
# Due to a limitation in the Windows edit controls, we are limited to one view
# per document, although nothing in this code assumes this (I hope!)

isRichText=1 # We are using the Rich Text control.  This has not been tested with value "0" for quite some time!

#ParentEditorDocument=docview.Document
from document import EditorDocumentBase
ParentEditorDocument=EditorDocumentBase
class EditorDocument(ParentEditorDocument):
	#
	# File loading and saving operations
	#
	def OnOpenDocument(self, filename):
		#
		# handle Unix and PC text file format.
		#

		# Get the "long name" of the file name, as it may have been translated
		# to short names by the shell.
		self.SetPathName(filename) # Must set this early!
		# Now do the work!
		self.BeginWaitCursor()
		win32ui.SetStatusText("Loading file...",1)
		try:
			f = open(filename,"rb")
		except IOError:
			win32ui.MessageBox(filename + '\nCan not find this file\nPlease verify that the correct path and file name are given')
			self.EndWaitCursor()
			return 0
		raw=f.read()
		f.close()
		contents = self.TranslateLoadedData(raw)
		rc = 0
		if win32ui.IsWin32s() and len(contents)>62000: # give or take a few bytes
			win32ui.MessageBox("This file is too big for Python on Windows 3.1\r\nPlease use another editor to view this file.")
		else:
			try:
				self.GetFirstView().SetWindowText(contents)
				rc = 1
			except TypeError: # Null byte in file.
				win32ui.MessageBox("This file contains NULL bytes, and can not be edited")
				rc = 0
				
			self.EndWaitCursor()
			self.SetModifiedFlag(0) # No longer dirty
			self._DocumentStateChanged()
		return rc

	def TranslateLoadedData(self, data):
		"""Given raw data read from a file, massage it suitable for the edit window"""
		# if a CR in the first 250 chars, then perform the expensive translate
		if data[:250].find('\r')==-1:
			win32ui.SetStatusText("Translating from Unix file format - please wa
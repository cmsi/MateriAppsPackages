#!/usr/bin/python2

# CASINO Setup GUI written by Synge Todo

import sys
import os
import shutil
import subprocess
import wx

import config

class Frame(wx.Frame):
    def __init__(self, prefix, scriptdir):
        self.prefix = prefix
        self.scriptdir = scriptdir
        self.process_download = None
        self.process_compile = None
        self.process_kill = False
        self.on_dialog = False

        wx.Frame.__init__(self, None, -1, "CASINO Setup", size = (420,500))
        self.panel = wx.Panel(self, -1)

        layout = wx.BoxSizer(wx.VERTICAL)

        self.radio_download_pw = wx.RadioButton(self.panel, -1, "Download source with username and password")
        self.radio_download_pw.Bind(wx.EVT_RADIOBUTTON, self.OnChooseRadioDownloadPw)
        self.radio_download_pw.SetValue(True)
        layout.Add(self.radio_download_pw, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)
        grid_1 = wx.FlexGridSizer(2, 3)
        self.text_username = wx.TextCtrl(self.panel, -1, size = (285, -1))
        self.text_username.Bind(wx.EVT_TEXT, self.OnTextUsername)
        self.text_password = wx.TextCtrl(self.panel, -1, style = wx.TE_PASSWORD)
        self.text_password.SetMaxLength(8)
        self.text_password.Bind(wx.EVT_TEXT, self.OnTextPassword)
        grid_1.Add(wx.StaticText(self.panel, -1, '     '), 0)
        grid_1.Add(wx.StaticText(self.panel, -1, "Username:"), 0, wx.RIGHT, 4)
        grid_1.Add(self.text_username, 1, wx.EXPAND, 4)
        grid_1.Add(wx.StaticText(self.panel, -1, '     '), 0)
        grid_1.Add(wx.StaticText(self.panel, -1, "Password:"), 0, wx.RIGHT | wx.TOP, 4)
        grid_1.Add(self.text_password, 1, wx.EXPAND | wx.TOP, 4)
        layout.Add(grid_1, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)

        self.radio_download_url = wx.RadioButton(self.panel, -1, "Download source from temporary URL")
        self.radio_download_url.Bind(wx.EVT_RADIOBUTTON, self.OnChooseRadioDownloadUrl)
        layout.Add(self.radio_download_url, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)
        grid_2 = wx.FlexGridSizer(2, 3)
        self.text_url = wx.TextCtrl(self.panel, -1, size = (285, -1))
        self.text_url.Bind(wx.EVT_TEXT, self.OnTextUrl)
        grid_2.Add(wx.StaticText(self.panel, -1, '     '), 0)
        grid_2.Add(wx.StaticText(self.panel, -1, "URL:"), 0, wx.RIGHT, 4)
        grid_2.Add(self.text_url, 1, wx.EXPAND, 4)
        layout.Add(grid_2, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)

        self.radio_local = wx.RadioButton(self.panel, -1, "Use a source tarball on local storage")
        self.radio_local.Bind(wx.EVT_RADIOBUTTON, self.OnChooseRadioLocal)
        layout.Add(self.radio_local, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)
        grid_3 = wx.FlexGridSizer(2, 3)
        self.text_file = wx.TextCtrl(self.panel, -1, size = (325, -1), style = wx.TE_READONLY)
        self.button_choose = wx.Button(self.panel, -1, "Choose")
        self.button_choose.Bind(wx.EVT_BUTTON, self.OnChoose)
        grid_3.Add(wx.StaticText(self.panel, -1, '     '), 0)
        grid_3.Add(wx.StaticText(self.panel, -1, "File:"), 0, wx.RIGHT | wx.TOP, 4)
        grid_3.Add(self.text_file, 1, wx.EXPAND | wx.TOP, 4)
        grid_3.Add(wx.StaticText(self.panel, -1, ''), 0)
        grid_3.Add(wx.StaticText(self.panel, -1, ''), 0)
        grid_3.Add(self.button_choose, 0, wx.TOP, 4)
        layout.Add(grid_3, 0, wx.LEFT | wx.RIGHT | wx.TOP, 10)

        box_1 = wx.BoxSizer(wx.HORIZONTAL)
        self.button_help = wx.Button(self.panel, -1, "Help", size=(70,30))
        self.button_help.Bind(wx.EVT_BUTTON, self.OnHelp)
        self.button_cancel = wx.Button(self.panel, -1, "Cancel", size=(70,30))
        self.button_cancel.Bind(wx.EVT_BUTTON, self.OnCancel)
        self.button_install = wx.Button(self.panel, -1, "Install", size=(70,30))
        self.button_install.Bind(wx.EVT_BUTTON, self.OnInstall)
        box_1.Add(self.button_help, 0, wx.LEFT | wx.BOTTOM, 5)
        box_1.Add(self.button_cancel, 0, wx.LEFT | wx.BOTTOM, 5)
        box_1.Add(self.button_install, 0, wx.LEFT | wx.BOTTOM, 5)
        layout.Add(box_1, 0, wx.ALIGN_BOTTOM | wx.ALIGN_RIGHT | wx.RIGHT | wx.TOP, 10)

        self.text_log = wx.TextCtrl(self.panel, -1, style=wx.TE_MULTILINE | wx.TE_READONLY, size=(50,10))
        layout.Add(self.text_log, 1, wx.LEFT | wx.RIGHT | wx.TOP | wx.BOTTOM | wx.EXPAND, 10)
                                    
        self.panel.SetSizer(layout)
        
        self.Bind(wx.EVT_CLOSE, self.OnClose)
        self.Bind (wx.EVT_IDLE, self.OnIdle)
        self.UpdateState()

    def OnCancel(self, event):
        if (self.process_download):
            self.on_dialog = True
            dialog = wx.MessageDialog(None, 'Downloading is now proceeding.  Stop download?', 'CASINO Setup', wx.YES_NO | wx.NO_DEFAULT | wx.ICON_EXCLAMATION)
            if dialog.ShowModal() == wx.ID_YES:
                self.process_kill = True
            dialog.Destroy()
            self.on_dialog = False
        elif (self.process_compile):
            self.on_dialog = True
            dialog = wx.MessageDialog(None, 'Compilation is now proceeding.  Stop compilation?', 'CASINO Setup', wx.YES_NO | wx.NO_DEFAULT | wx.ICON_EXCLAMATION)
            if dialog.ShowModal() == wx.ID_YES:
                self.process_kill = True
            dialog.Destroy()
            self.on_dialog = False
        else:
            self.Destroy()
        self.UpdateState()

    def OnChoose(self, event):
        self.OpenFileDialog()
        self.UpdateState()

    def OnChooseRadioDownloadPw(self, event):
        self.UpdateState()

    def OnChooseRadioDownloadUrl(self, event):
        self.UpdateState()

    def OnChooseRadioLocal(self, event):
        if (not self.text_file.GetValue()):
            self.OpenFileDialog()
        self.UpdateState()

    def OnClose(self, event):
        if (self.process_download or self.process_compile):
            self.OnCancel(event)
        if (not (self.process_download or self.process_compile)):
            self.Destroy()
        self.UpdateState()

    def OnHelp(self, event):
        wx.BeginBusyCursor() 
        import webbrowser
        webbrowser.open('file://' + scriptdir + '/help.html') 
        wx.EndBusyCursor() 
        
    def OnIdle(self, event):
        if (self.on_dialog): return
        if (self.process_download):
            ret = self.process_download.poll()
            if (ret == None):
                if (self.process_kill):
                    self.process_kill = False
                    self.process_download.kill()
                    self.process_download = None
                    self.text_log.AppendText('Killed.')
                    self.UpdateState()
                else:
                    line = self.process_download.stdout.readline()
                    self.text_log.AppendText(line)
            else:
                self.process_download = None
                if (ret != 0):
                    dialog = wx.MessageDialog(None, 'Invalid username and/or password', 'Error', wx.OK | wx.ICON_ERROR)
                    dialog.ShowModal()
                    dialog.Destroy()
                else:
                    self.StartCompile(os.path.join(self.prefix, 'source', config.file))
                self.UpdateState()
        elif (self.process_compile):
            ret = self.process_compile.poll()
            if (ret == None):
                if (self.process_kill):
                    self.process_kill = False
                    self.process_compile.kill()
                    self.process_compile = None
                    self.text_log.AppendText('Killed.')
                    self.UpdateState()
                else:
                    line = self.process_compile.stdout.readline()
                    self.text_log.AppendText(line)
            else:
                self.process_compile = None
                if (ret != 0):
                    dialog = wx.MessageDialog(None, 'Error occured during compilation', 'Error', wx.OK | wx.ICON_ERROR)
                    dialog.ShowModal()
                    dialog.Destroy()
                else:
                    dialog = wx.MessageBox('Installation completed', 'CASINO Setup')
                    self.Destroy()
                self.UpdateState()

    def OnInstall(self, event):
        if (self.radio_download_pw.GetValue()):
            target = os.path.join(self.prefix, 'source')
            tarball = os.path.join(target, config.file)
            username = self.text_username.GetValue()
            password = self.text_password.GetValue()
            if (os.path.exists(tarball)):
                dialog = wx.MessageDialog(None, tarball + ' already exists.  Remove it and continue download?', 'CASINO Setup', wx.OK | wx.CANCEL | wx.ICON_QUESTION)
                if dialog.ShowModal() == wx.ID_OK:
                    dialog.Destroy()
                    os.remove(tarball)
                else:
                    dialog.Destroy()
                    self.text_file.SetValue(tarball)
                    self.radio_local.SetValue(True)
                    self.UpdateState()
                    return
            self.StartDownloadPw(username, password, target)
        elif (self.radio_download_url.GetValue()):
            target = os.path.join(self.prefix, 'source')
            tarball = os.path.join(target, config.file)
            url = self.text_url.GetValue()
            if (os.path.exists(tarball)):
                dialog = wx.MessageDialog(None, tarball + ' already exists.  Remove it and continue download?', 'CASINO Setup', wx.OK | wx.CANCEL | wx.ICON_QUESTION)
                if dialog.ShowModal() == wx.ID_OK:
                    dialog.Destroy()
                    os.remove(tarball)
                else:
                    dialog.Destroy()
                    self.text_file.SetValue(tarball)
                    self.radio_local.SetValue(True)
                    self.UpdateState()
                    return
            self.StartDownloadUrl(url, target)
        else:
            file = self.text_file.GetValue()
            if (file):
                self.StartCompile(file)
            else:
                dialog = wx.MessageDialog(None, 'Please specify source archive', 'Error',
                                          wx.OK | wx.ICON_ERROR)
                dialog.ShowModal()
                dialog.Destroy()
        self.UpdateState()

    def OnTextUsername(self, event):
        self.UpdateState()

    def OnTextPassword(self, event):
        self.UpdateState()

    def OnTextUrl(self, event):
        self.UpdateState()

    def OpenFileDialog(self):
        wildCard = "tar.gz file (*.tar.gz)|*.tar.gz|All files (*.*)|*.*"
        if (self.text_file.GetValue()):
            path = os.path.dirname(self.text_file.GetValue())
        else:
            path = os.environ['HOME']
        dialog = wx.FileDialog(self, "Choose a source archive", path, '', wildCard, wx.OPEN)
        if dialog.ShowModal() == wx.ID_OK:
            self.text_file.SetValue(dialog.GetPath())
            self.radio_local.SetValue(True)
        dialog.Destroy()

    def StartCompile(self, file):
        casinodir = os.path.join(self.prefix, 'share', 'casino')
        if (os.path.exists(casinodir)):
            dialog = wx.MessageDialog(None, casinodir + ' already exists.  Clean up and install CASINO anyway?', 'CASINO Setup', wx.OK | wx.CANCEL | wx.ICON_QUESTION)
            if dialog.ShowModal() == wx.ID_OK:
                shutil.rmtree(casinodir)
                dialog.Destroy()
            else:
                dialog.Destroy()
                return            
        cmd = ['/bin/sh', os.path.join(self.scriptdir, 'compile.sh'), file, self.prefix]
        self.process_compile = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                                stderr=subprocess.STDOUT,
                                                stdin=subprocess.PIPE)
        self.text_log.AppendText('Start compilation of CASINO\n')

    def StartDownloadPw(self, username, password, target):
        cmd = ['python2', os.path.join(self.scriptdir, 'download_pw.py'), username, password, target]
        self.process_download = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                                    stderr=subprocess.STDOUT,
                                                    stdin=subprocess.PIPE)
        self.text_log.AppendText('Start download of CASINO\n')
        
    def StartDownloadUrl(self, url, target):
        cmd = ['python2', os.path.join(self.scriptdir, 'download_url.py'), url, target]
        self.process_download = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                                 stderr=subprocess.STDOUT,
                                                 stdin=subprocess.PIPE)
        self.text_log.AppendText('Start download of CASINO\n')
        
    def UpdateState(self):
        if (self.process_download or self.process_compile):
            self.radio_download_pw.Disable()
            self.radio_download_url.Disable()
            self.radio_local.Disable()
            self.text_username.Disable()
            self.text_password.Disable()
            self.text_url.Disable()
            self.text_file.Disable()
            self.button_choose.Disable()
            self.button_help.Disable()
            self.button_install.Disable()
        else:
            self.radio_download_pw.Enable()
            self.radio_download_url.Enable()
            self.radio_local.Enable()
            self.button_choose.Enable()
            self.button_help.Enable()
            if (self.radio_download_pw.GetValue()):
                self.text_username.Enable()
                self.text_password.Enable()
                self.text_url.Disable()
                self.text_file.Disable()
                if (self.text_username.GetValue() and self.text_password.GetValue()):
                    self.button_install.Enable()
                else:
                    self.button_install.Disable()
            elif (self.radio_download_url.GetValue()):
                self.text_username.Disable()
                self.text_password.Disable()
                self.text_url.Enable()
                self.text_file.Disable()
                if (self.text_url.GetValue()):
                    self.button_install.Enable()
                else:
                    self.button_install.Disable()
            else:
                self.text_username.Disable()
                self.text_password.Disable()
                self.text_url.Disable()
                self.text_file.Enable()
                if (self.text_file.GetValue()):
                    self.button_install.Enable()
                else:
                    self.button_install.Disable()

if __name__ == '__main__':
    if (len(sys.argv) < 2):
        print "Usage:", sys.argv[0], "prefix"
        sys.exit(127)
    scriptdir = os.path.abspath(os.path.dirname(sys.argv[0]))
    prefix = sys.argv[1]
    app = wx.App()
    frame = Frame(prefix, scriptdir)
    frame.Show()
    app.MainLoop()
    app.Destroy()

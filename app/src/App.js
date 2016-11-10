import React, { Component } from 'react';
import AppBar from 'material-ui/AppBar';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import lightBaseTheme from 'material-ui/styles/baseThemes/lightBaseTheme';
import { green500, green700, amber700 } from 'material-ui/styles/colors';
import { css } from 'aphrodite';
import styles from './styles';

class App extends Component {
  render() {
    return (
        <MuiThemeProvider
          muiTheme={getMuiTheme(lightBaseTheme, { palette: {
            primary1Color: green500,
            primary2Color: green700,
            accent1Color: amber700,
          }})}>
          <div className={css(styles.wrapper)}>
            <AppBar title="wETHer Insurance" iconClassNameRight="muidocs-icon-navigation-expand-more" />
            {this.props.children}
          </div>
        </MuiThemeProvider>
    );
  }
}

export default App;

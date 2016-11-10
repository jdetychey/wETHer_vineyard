import { StyleSheet } from 'aphrodite';

const styles = StyleSheet.create({
  wrapper: {
    display: 'flex',
    minHeight: '100vh',
    flexDirection: 'column'
  },
  homeCoverButtonDiv: {
    bottom: '1vh',
    position: 'fixed',
    width: '100%',
    padding: '1em'
  },
  home: {
    minHeight: '100vh',
    background: 'url(farmer.jpg) no-repeat center center fixed',
    backgroundSize: 'cover'
  },
  parameters: {
    padding: '1rem',
  },
  parampaper: {
    padding: '1em'
  },
  papertitle: {
    textAlign: 'center',
    marginTop: 0,
    marginBottom: '2em'
  },
  huge: {
    textAlign: 'center',
    fontSize: '3em',
    fontWeight: 'bold',
    marginBottom: '1em'
  },
  premiumCoverButtonDiv: {
    bottom: '1vh',
    position: 'fixed',
    width: '100%',
    padding: '1em'
  },
  resulthash: {
    overflowWrap: 'break-word',
    wordWrap: 'break-word',
    wordBreak: 'break-all'
  }
});

export default styles;

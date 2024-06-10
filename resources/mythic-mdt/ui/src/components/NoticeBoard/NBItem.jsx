import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  Avatar,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
} from "@mui/material";
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { toast } from "react-toastify";
import { Link } from "react-router-dom";
import Moment from "react-moment";
import Truncate from "@nosferatu500/react-truncate";

import { Modal, UserContent } from "../";
import { Sanitize } from "../../util/Parser";
import Nui from "../../util/Nui";
import { usePerson, usePermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
  wrapper: {
    userSelect: "none",
    transition: "background ease-in 0.15s",
    "&:hover": {
      cursor: "pointer",
      background: theme.palette.secondary.dark,
    },
  },
  time: {
    fontSize: 14,
    color: theme.palette.text.alt,
  },
  officerLink: {
    color: theme.palette.text.alt,
    transition: "color ease-in 0.15s",
    "&:hover": {
      color: theme.palette.primary.main,
    },
    "&:not(:last-of-type)": {
      content: '", "',
      color: theme.palette.text.main,
    },
  },
}));

export default ({ notice }) => {
  const classes = useStyles();
  const hasPerms = usePermissions();
  const user = useSelector(state => state.app.user);
  const canDelete = hasPerms(true) || notice.author == user.SID;
  const [open, setOpen] = useState(false);

  const onDismiss = async () => {
    if (!canDelete) return;
    try {
      let res = await (
        await Nui.send("Delete", {
          type: "notice",
          id: notice._id,
        })
      ).json();

      if (res) {
        toast.success("Notice Dismissed");
      } else toast.error("Unable to Dismiss Notice");
    } catch (err) {
      console.log(err);
      toast.error("Unable to Dismiss Notice");
    }
    setOpen(false);
  };

  return (
    <>
      <ListItem className={classes.wrapper} onClick={() => setOpen(true)}>
        <ListItemAvatar>
          <Avatar>
            <FontAwesomeIcon icon={["fas", notice.job ? 'lock' : 'circle-info']} />
          </Avatar>
        </ListItemAvatar>
        <ListItemText
          primary={<Truncate lines={1}>{notice.title}</Truncate>}
          secondary={<Truncate lines={1}>{Sanitize(notice.description)}</Truncate>}
        />
        <Moment className={classes.time} date={notice.time} fromNow />
      </ListItem>
      <Modal
        open={open}
        title={notice.title}
        deleteLang="Delete"
        onClose={() => setOpen(false)}
        onDelete={canDelete ? onDismiss : null}
      >
        <List className={classes.author}>
            <UserContent
                wrapperClass={classes.notes}
                content={notice.description}
            />
            <ListItem>
                <ListItemText 
                    primary="Created On"
                    secondary={<Moment date={notice.time} format="LLL" />}
                />
            </ListItem>
        </List>
      </Modal>
    </>
  );
};